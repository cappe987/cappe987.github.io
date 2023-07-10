---
layout: post
title: Synchronization and Syntonization
date: 2023-07-10
tags: ["networks", "linux"]
categories: networks
description: Aligning and keeping clocks aligned
published: true
---

Setting two clocks to the same time doesn't seem that hard, right? If
same-second precision is enough for you then you can usually do that. But when
we are talking nanosecond precision like that provided by PTP (IEEE1588,
Precision Time Protocol) there are some more variables to consider.

## Synchronization

The first variable to note is the time it takes to set the new time. Even if the
action to set the time is triggered at the exact same time, the OS will
introduce latency in the operation. Anything that depends on the OS being
precise in its operations is out of the question. For this reason the
adjustments should be done through adjustments rather than setting an absolute
time. By knowing the difference between two clocks the time can be adjusted by
that much to synchronize them. Doing this with PTP is explained in [this
post]({{< ref "2023-04-05-ptp-intro-timestamping.md" >}}).

Assuming the initial difference calculated is precise then this will bring the time
difference hopefully within maybe a microsecond.



## Syntonization

Now that the clocks are nearly aligned we need to consider the frequency of the
oscillators driving the clocks. If two clocks driven by oscillators
at different frequencies, or even just of different qualities, it will result in
wander. A big difference will allow significant wander in between every
synchronization, resulting in never reaching near-perfect accuracy. When the
clocks are within a certain threshold time adjustment can stop and clock
syntonization starts. The slave clocks will adjust their operating frequency.
Though not literally the frequency, but rather a compensation value the clock
will take into account when advancing its time. The frequency is adjusted so
the time difference between the clocks approaches 0. If the slave time is behind
it needs to increase the frequency gradually until it catches up, at which point
it will start fluctuating back and fourth just around the frequency of the
master.



## Holdover

Clock holdover time is how long it can stay within a certain offset from the
master after losing the synchronization (e.g. losing connection). A typical
requirement is that it should keep some accuracy during 5 seconds loss. In terms
of PTP this may happen if its master clock goes down and it needs to find an new
master. And during those 5 seconds while waiting for a new master it cannot
wander too far away from the initial time.



## Physical Hardware Clock

When requiring nanosecond-precision timekeeping a hardware clock is used. In
Linux this is referred to as a Physical Hardware Clock (PHC). It keeps the time
and allows some operations to manage it.

1. Set time
1. Get time
1. Adjust time
1. Set frequency

Points 1) and 2) are not required by PTP, but are useful for debugging. 3) is
the one that is used to adjust for the difference. 4) sets the frequency of the
PHC. These operations can be accessed using the `phc_ctl` tool from the Linuxptp
project (along with some more operations).

In Linux the PHC are exposed as devices under `/dev`, typically as `/dev/ptpN`,
where `N` denotes the number of the PHC.

### Set time
The time set is an absolute value in Unix time. Meaning a value of 10 sets the
time to 1970-01-01 00:00:10.
```
phc_ctl /dev/ptp0 set 10
```

### Get time
Reads out the time
```
phc_ctl /dev/ptp0 get
```
### Adjust time
Increments or decrements the clock by the given time in seconds, read as double
precision floating point values.
```
phc_ctl /dev/ptp0 adj 10.5
```

### Set frequency
Sets the frequency of the clock in ppb (parts-per-billion), meaning how many
nanoseconds per second it should it should stray from its real frequency. Note
that each PHC has different maximum frequency adjustments. The PHC capabilities
can be viewed with `phc_ctl /dev/ptp0`.
```
phc_ctl /dev/ptp0 freq 1222
```


## Time scales and leap seconds

International Atomic Time (TAI) operates based on a weighted average of over 450
atomic clocks spread out around earth. Universal Coordinated Time (UTC) is based
on the actual earths rotation. In TAI a day is defined as having exactly 86 400
seconds, while UTC is subject to leap seconds. Leap seconds occur due to earths
rotation speed always changing slightly due to geological or climatic changes,
e.g. the continental plates moving or the ice caps melting. Since this cannot be
predicted over longer periods a leap second is only announced 6 months in
advance.

The leap seconds always happen on either June 30th or December 31st at 23:59:59.
A leap second ahead is shown as 23:59:60, before advancing to 00:00:00. A leap
second backwards goes directly from 23:59:58 to 00:00:00. As for when a leap
second occurs, a Linux system should be informed by an NTP daemon when when is
scheduled, which in turn gets its time through NTP from a more authoritative
clock device.

PTP operates on the TAI timescale, but always informs of the current UTC offset
(37 at the time of writing) to make sure any devices that need the time in UTC
can convert to it.
