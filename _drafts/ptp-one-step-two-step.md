---
layout: post
title: "PTP - one-step vs two-step"
date: 2023-03-22
tags: networks programming
description: A quick comparison of timestamping methods
published: false
---

**TODO: add introduction**

When using PTP you need to be able to accurately determine the transmission and
receival. To do this we use hardware timestamping. When the hardware receives a
packet it will save the timestamp and save it in packet metadata that can then
be fetched by the receiver.

The transmission is a bit trickier because you can't include metadata on the
wire. There are two solutions to this. The simplest one is to send one packet,
take the timestamp from when it was sent, and then send a follow-up that
includes the transmission of the first packet. This is called two-step
timestamping.

The other alternative is to have hardware that can detect and modify the right
fields in the PTP packets as they go out on the wire.

Two-step timestamping only requires the networking hardware to be able to
timestamp packets. This is done either in the MAC or the PHY. The PHY will
provide more accurate timestamps since it allows it to be the last action
before it goes on the wire. Doing it in the MAC can give slightly higher
variation on the accuracy, but for many use-cases it is still good enough.

For one-step timestamping you also need the functionality to modify the packet,
and that includes understanding the PTP packets. The main benefit of one-step
is that you get less packets to handle and maybe slightly faster convergence
since it never has to wait for a second packet. Though with the introduction of
the standard 802.1AS it has shown that two-step can perform just as well. The
extra traffic on the network is so insignificant that it doesn't really affect
anything.

**TODO: double check this against PDF I found**
https://www.ieee802.org/1/files/public/docs2015/ASRev-pannell-To-1-step-or-not-0315-v1.pdf
At first it may seem like there is no reason to not use one-step. It's a
reasonable assumption. But when you reach speeds of 10Gbit and higher you will
incur penalties for the time you spend timestamping and modifying the packet.
The network transmits fast enough that it takes longer to add the time than the
actual transmission. This means that it can't transmit at full wire speed.

This could be solved by predicting the transmit time and preparing the packet
ahead of time. The drawback there is that it adds latency to all the packets
(not just PTP packets) that goes out on the wire.

**TODO: add pdf as reference**


