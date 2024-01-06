---
layout: post
title: ts2phc and synchronizing hardware clocks
date: 2024-01-06
tags: ["networks", "linux"]
categories: networks
description: How to use ts2phc to synchronize clocks
published: true
---

The Precision Time Protocol, PTP, is used for synchronizing time across the
network. But what if the clocks I want to synchronize are all internal?

In previous posts, I have explained parts of PTP and how that is used to
synchronize devices in a network. PTP is often done with the `ptp4l` daemon from
the Linuxptp project, and it is overall a well-explained protocol across the
web. There are many resources. The project also provides a couple of other
tools, one of which is `ts2phc`, which has way less documentation about it
online. This post will focus on what it does and why it's needed.

## Why is it needed?

Some network switches will only have a single PHC that is shared across all
ports. In this case, no synchronization is needed. If instead the PHC and
timestamping are located in the PHY there is one PHC per port (or 2/4 ports for
dual/quad PHY). When running PTP across multiple PHYs their time needs to be
synchronized. For a Transparent Clock, they will never be adjusted by PTP, but
they must still have the same time. Running `ts2phc` on them will ensure that
they always stay within a few nanoseconds of each other. For a Boundary Clock,
the time of one PHY will constantly be adjusted by PTP (the port towards the PTP
Grandmaster), while the other ports act as masters for downstream clocks.
Internally the PHY towards the Grandmaster will act as a master for the other
PHY clocks to make sure that the time transmitted downstream is in sync with
upstream.

For Transparent Clocks, a single alignment pulse can sometimes be used to make
all clocks start their time counting at the same time, and then never need to be
synchronized again. But this depends on the PHYs and there is no official
support for this in Linux and requires all PHYs to run on the same oscillator.



## How synchronization works

Internal clocks do not have any network connections between them, so reusing the
PTP daemon isn't an option. The naive approach would be to read out the current
time from each clock, compare them, and adjust the clocks accordingly. This is
what the Linuxptp application `phc2sys` does. But as the name suggests the
purpose of it is to synchronize the time of a Physical Hardware Clock (PHC) to
the system. Or vice versa if the system acts as the Grandmaster clock of the
network. As for synchronizing two PHCs this simply isn't good enough. The
precision will be unacceptable compared to the precision you can reach with PTP;
a Boundary/Transparent clock that does this will probably introduce more
inaccuracy than if it just forwarded the PTP packet in hardware.

To the rescue comes the Linuxptp application `ts2phc`. This application needs
some specialized hardware design to work. The issue with phc2sys is that
comparing timestamps that are taken at different times inherently gives
inaccurate results. For perfect synchronization, the timestamps must be taken as
close together as possible. The solution for this is a signal line in the PCB.
Each PHC is set up by `ts2phc` to take a timestamp when a pulse is received on
that line. A pulse is then triggered and timestamps are read out from all PHC,
compared, and adjusted.

On the hardware, the different PHCs need to be connected on a single line, as
shown below. One of the clocks will be configured to send out the pulse, while
the other two are configured to timestamp the pulse. The line may be subject to
some propagation delay on large boards. Online resources suggest 1 nanosecond
per 15cm[^1]. Which for normal PTP operation probably isn't enough to worry
about.

```txt
  +-------+-------+
  |       |       |
+----+  +----+  +----+
|PHC1|  |PHC2|  |PHC3|
+----+  +----+  +----+
```

## Linux kernel API

The Linux kernel exposes two APIs for this purpose. EXTTS (EXTernal TimeStamp)
configures the PHC to timestamp on a signal on a specific hardware pin. PEROUT
(PERiodic OUTput) configures a PPS (Pulse-Per-Second) signal on one of the PHCs
that will trigger every time the PHC is at a whole second time.

The PHC dedicated as master will be configured with PEROUT, while the rest are
EXTTS. Because the PPS is always triggered at a whole second it can find the
timestamp of the master PHC by reading the current time and rounding down,
assuming we do it within a second (i.e. before the next signal). In theory,
however, there is no requirement for the pulse to happen every second. It's
fully possible to have something external trigger a pulse to all PHC, including
the master (the master also needs to be configured for EXTTS in this case). It's
also possible for the PHC sending PPS to be treated as slave and be adjusted.
What is important is that there is a timestamp from every clock that we can
compare.

## Combining it with PTP

For every setup there needs to be one master PHC and the rest are slaves. The
slaves are compared to and adjusted to match the time of the master. `ts2phc`
expects one PHC to be configured as master. But there are cases when a dynamic
setup is required, e.g. when running a PTP Boundary Clock across the PHCs. The
master PHC must always be the one acting as PTP slave, the one in the direction
of the Grandmaster, as this is the one being adjusted from an external source.
This time must be distributed to all other PHCs for the time to continue being
accurate downstream. If the Grandmaster changes position and another PHC is now
being adjusted by PTP then `ts2phc` also requires changing master. To do this the
command line argument `ts2phc -a` can be used to listen to port state events
from `ptp4l`. Now ts2phc will always match its master to the PTP slave port.

It may also be useful to set the option `ts2phc --step_threshold=0.0001` to
allow stepping the clocks. Otherwise, the clocks can end up stabilizing
internally before a Grandmaster is found, and will then take a long time to
converge.

[^1]: https://madpcb.com/glossary/propagation-delay




