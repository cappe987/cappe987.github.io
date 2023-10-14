---
layout: post
title: PTP peer delay measurement
date: 2023-10-12
tags: ["networks"]
categories: networks
description: Methods of measuring peer delay
published: true
---


To accurately synchronize the time we need to account for all time lost as the
packet travels. One part of this is the time it takes for packets to travel
across the cable, including egress time after the timestamp is taken, and
ingress time before the timestamp is taken. Though measuring the time it takes
from one device to another is impossible because they will never have the exact
same time, so a timestamp on one side is not guaranteed to match up with a
timestamp on the other side. We have to settle for measuring the roundtrip time
and dividing it by 2, and hope that the delay is symmetric.


## Two-step peer delay

This is similar to how two-step for synchronization works, we send a packet,
timestamp the egress time, and send a follow-up packet containing the egress
time of the first. Two-step peer delay can be done in two different ways, but
let us explore the concept first.


### Two-step using full timestamps

Two devices running PTP in peer delay mode will both measure the peer delay
independently. But here I will focus on the transaction from the perspective of
one side. Call one side *client* and the other side the *server*. In reality,
both will be both client and server.

1. Client sends a peer delay request `PDELAY_REQ`. It is timestamped `t1` on
   egress and kept by the client.
2. Server receives `PDELAY_REQ` and timestamps it `t2`.
3. Server sends a peer delay response `PDELAY_RESP` containing `t2`. It is
   timestamped `t3`.
4. Client receives `PDELAY_RESP` containing `t2`. It is timestamped `t4`.
5. Server sends a peer delay response follow-up `PDELAY_RESP_FUP` containing
   `t3`.
6. Client receives `PDELAY_RESP_FUP` containing `t3`.

Now the client has all 4 timestamps:
- `t1`: egress time of request
- `t2`: ingress time of request
- `t3`: egress time of response
- `t4`: ingress time of response

```sh
________t1   t2________
|Client|>----->|Server|
|______|<-----<|______|
        t4   t3
```

The formula for calculating the peer delay (meanPathDelay) time looks like this

```sh
meanPathDelay = ((t4-t1) - (t3-t2))/2
```

`t3-t2` represents the time it spent inside the server device, often called
*residence time*. `t4-t1` represents the total time the packet was away. The
total time on the wire is then found by subtracting the residence time from the
total time. Dividing by 2 gives the mean delay.

### Two-step using correctionField

In this method all the timestamps are still taken the same way as above. But
instead of sending the timestamps back, those fields are simply set to zero, and
the time `t3-t2` is added to correctionField of the `PDELAY_RESP_FUP`.

The full formula is actually slightly longer than what was shown above, to allow
for other forms of compensation

```sh
meanPathDelay = ((t4-t1) - (t3-t2) - pdelay_resp.correction -
pdelay_resp_fup.correction)/2
```

Here we will now have `t2` and `t3` set to zero on the clients side. And that
time instead comes in the `pdelay_resp_fup.correction`. The end result is the
same. And the server side can choose which method to use since it doesn't matter
to the client.

CorrectionField contains a number of nanoseconds that should be subtracted by
the receiver. This exists to allow other forms of compensation as well. The
Switchcore or  PHY may add compensation for the time it introduces after
timestamping.


## One-step peer delay

This works similar to one-step synchronization, and uses the correctionField
approach explained above. For this the response ingress timestamp `t2` is placed
in the `reserved2` field (4 bytes) before the response is sent. This field is
smaller than the full timestamp, so it only has 2^32 time units to send the
response. Past that it will no longer match to the correct ingress time. If the
time units are nanoseconds then it calculates to ~4.3 seconds, which is plenty
of time to send a response.

On egress, the timestamp `t3` is taken, and `t3-t2` is added to the
correctionField on the fly. Now the residence time is calculated and sent back
to the client, which now uses the following formula

```sh
meanPathDelay = ((t4-t1) - pdelay_resp.correction)/2
```

Note that the full formula from above can still be used, as the unused values
will be 0 (and there will be no follow-up).


## 1.5-step peer delay

This is a combination of two-step and one-step, and can be applied to both sync
and peer delay[^1]. The idea is that the protocol still behaves the same as
two-step. I.e. it sends follow-up packets. The difference here is that the
timestamp, e.g. `t1`, is just kept in the timestamping hardware and is not read
out by the CPU. When the matching follow-up (requesting port ID and sequence ID
matches) comes to the hardware the timestamp is filled in. When it goes on the
wire it now looks like a normal two-step.

The benefit of this is because one-step adds latency to the transmission
as it has to stop, take the timestamp just before transmitting, and then
modify the packet. At speeds of 10Gbit and higher it starts affecting the
transmission speed. The follow-up doesn't have to be modified exactly at
transmission time, it can be prepared ahead of time so it doesn't affect the
latency. By eliminating the readout it minimizes the overhead of sending
packets. Meaning the follow-up packet can be sent immediately after the initial
sync/pdelay_resp.

1.5-step is not formulated in any standard because it does not affect the
perception. From a protocol point-of-view it is still two-step.

[^1]: <https://www.ieee802.org/1/files/public/docs2015/ASRev-pannell-To-1-step-or-not-0315-v1.pdf>


