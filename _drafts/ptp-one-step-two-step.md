---
layout: post
title: PTP and timestamping methods
date: 2023-03-26
tags: networks
description: A maybe not so gentle introduction to the Precision Time Protocol
published: false
---

Computers in networks traditionally don't have any knowledge of when other
computers can/will transmit data. Dozens of devices transmitting data whenever
they want will inevitably lead to collisions and congestions at one point or
another, which in turn leads to packets not arriving as soon as they should.
Packets arriving later than intended may affect what the receiver should do with
it. Data can expire. If the timeframe for its usefulness has passed then the
receiver must know this, or else it may perform actions based on old
information. There exist techniques to improve predictability in networks, but
this post will focus on a common understanding of time.

Clock synchronization across the internet typically uses software timestamping
to make sure your computer clock shows the same as the rest of the world
(disregarding timezones). In a best-case scenario software timestamping can
reach a precision of under a millisecond, but also a worst-case of hundreds of
milliseconds. To the human eye looking at a clock, this appears good enough, but
machines may require much higher precision in certain use cases.




# A new level of precision

The IEEE 1588 standard defines the Precision Time Protocol, also known as PTP.
This protocol allows synchronization of hardware clocks down to nanosecond
precision in a local network. Devices achieve this by timestamping packets they
send and receive and comparing the time, and estimating and adjusting according
to the cable delay. But using software timestamping still limits the precision
due to processor scheduling and other network traffic that creates variation in
the actual transmission time.

To solve this there exist ethernet ports with support for hardware
timestamping. PTP requires a device to know both the transmission and reception
time. Sending over only the current time from the master clock would make the
slave show an earlier time than the master since the master will have moved forward
by the time the slave has received and adjusted the clock. The participating
devices also need to determine how long delay the wire itself incurs. A long
cable, or even a time-unaware switch, can add noticeable delays (noticeable from
a nanosecond perspective).

Good! Now we have established the requirement! But how does this help us?

The synchronization process of a slave clock consists of two steps:
1. Getting the current time from a master clock
2. Finding the cable delay and adding that to the time received from the master

Step (1) involves the master sending the current time, taken as close to the
wire as possible, in a *Sync* packet to the slave. PTP defines two methods for
doing this: one-step and two-step. This is explained in more detail later. The
slave can now update its clock to the provided timestamp. The timestamp that
arrived has the value `master_clock - cable_delay`. If PTP only ever did step
(1) the slave would always stay behind the master by `cable_delay` time. Devices
would then end up further behind the further they are from the master, and each
intermediate switch would add more to that.

For step (2) the slave sends a *Delay_Req* (delay request) to the master and
records the transmission time (`t1`) for itself to use later. The master
timestamps the reception time (`t2`) of the message and sends that back in a
*Delay_Resp* (delay response) to the slave.

Because t1 was already `cable_delay` time behind the master clock, due to the
cable delay on the previous *Sync* packet, the difference between t1 and t2 will
now be `cable_delay * 2`. This means the slave clock should add `(t2-t1)/2` to
its clock. Now the master and slave clocks have successfully synchronized. The
process will then repeat at regular intervals to make sure everything stays
synchronized.



## Software daemon

The hardware only needs to implement the timestamping functionality to support
PTP. But managing these different types of packets, as well as deciding who
should be master and who should be slave, requires software. Usually in the form
of a daemon. Richard Cochran maintains the most popular implementation of PTP in
the project [linuxptp](https://github.com/richardcochran/linuxptp).



## One-step vs two-step

When the hardware receives a packet it will save the timestamp in packet
metadata that can then be fetched by the receiving application. Simple enough!

The transmission poses more of a challenge since metadata can't be included on
the wire. As mentioned earlier, there exist two methods for handling this. The
simplest one involves sending one packet, taking the timestamp from when it was
sent, and then sending a follow-up that includes the transmission of the first
packet. This is called two-step timestamping.

The other alternative, one-step timestamping, requires hardware that can detect
and modify the right fields in the PTP packets as they go out on the wire. That
way the packet contains the data.

Two-step only requires the networking hardware to be able to timestamp packets.
The timestamping happens either in the MAC hardware or the PHY hardware. The PHY
will provide better accuracy since it allows timestamping to be the last action
before the packet goes on the wire. Performing timestamping in the MAC can give
slightly higher variation in accuracy, but still good enough for many
use cases.

<style type="text/css">
pre > code {
      display: block !important;
      line-height: 1.3rem !important;
      font-size: 1.3rem !important;
}
</style>
 <!--┌───┐-->
 <!--│CPU│-->
 <!--└▲─┬┘-->
  <!--│ │-->
 <!--┌┴─▼┐-->
 <!--│MAC│-->
 <!--└▲─┬┘-->
  <!--│ │-->
 <!--┌┴─▼┐-->
 <!--│PHY│-->
 <!--└▲─▼┘-->
```
      ┌───┐
      │CPU│
      └─┬─┘
        │
      ┌─┴─┐
  ┌───┤MAC├───┐
  │   └─┬─┘   │
  │     │     │
┌─┴─┐ ┌─┴─┐ ┌─┴─┐
│PHY│ │PHY│ │PHY│
└▲─▼┘ └▲─▼┘ └▲─▼┘
```
The above illustration shows an example layout of how a MAC and PHY would be
attached in switching hardware. The PHY attaches directly to the cable.

For one-step, the hardware also needs the functionality to modify the packet,
and that includes understanding the PTP packet layout. Using one-step results in
fewer packets to handle and slightly faster convergence (time for all clocks in
the network to get accurately synced) since it never has to wait for a second
packet. Though with the introduction of the standard 802.1AS, it has been shown
that two-step can perform just as well, and the extra traffic on the network
becomes insignificant at the network speeds of today.

So why doesn't everyone use one-step? At the surface, it looks good, but looking
deeper one-step has some drawbacks. When reaching speeds of 10Gbit and higher it
will incur penalties for the time spent taking the timestamp and modifying the
packet[^1]. The network transmits fast enough that it takes longer to add the
time than the actual transmission. This means that the hardware can't work at
full wire speed while timestamping just before transmitting. To get around this
the hardware could try to predict the transmission time and prepare the packet
ahead of time. But that too has its issues as preparing ahead of time adds
latency to all outgoing packets on that port. A not-so desirable trait in
time-sensitive networks.



[^1]: <https://www.ieee802.org/1/files/public/docs2015/ASRev-pannell-To-1-step-or-not-0315-v1.pdf>

