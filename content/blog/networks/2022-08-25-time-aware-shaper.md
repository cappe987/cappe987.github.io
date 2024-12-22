---
layout: post
title: "TSN: Time-Aware Shaper"
date: 2022-08-25
tags: ["networks"]
categories: networks
description: "Time Sensitive Networking and the 802.1Qbv standard"
---

Let's dive a little deeper into Time-Aware Shapers, specified in the
IEEE 802.1Qbv standard. For a light introduction go read my [intro to
TSN]({{< ref "2022-06-07-tsn-intro.md" >}}).

## Gates
The shapers are applied on egress and each shaper has a list of time slots,
where each time slot specifies a `duration`, `operation`, and `gate_mask`. The
`duration` represents how long the time slot is. The `gate_mask` specifies
which egress queues are open during that time. Multiple queues can be
open at the same time, at which point it treats it as regular Strict Priority
between those queues, i.e., higher priority goes first. `operation` will be
covered later. Time-Aware Shapers can have a theoretically infinite number of
these time slots, also known as **gates**, but in practice there will of course
be a limit to what both the software and hardware can support. The sum of the
gates' durations defines the cycle time. When it has iterated through all the
gates it restarts with the first gate again. Below is an example of a schedule
with two gates, one which opens priorities 0-3 and one which opens priorities
4-7.

```no-hl
|---------|---------|---------|---------|
| 0,1,2,3 | 4,5,6,7 | 0,1,2,3 | 4,5,6,7 | ...
|---------|---------|---------|---------|
```

You should always make sure that all possible priorities in your system should
be able to send at least during one gate. Otherwise it will take up space in the
queue and never be sent. You can of course use only priorities 0-2 if you wish,
but then you must make sure that no priority is ever mapped to the rest. The
priority is usually the PCP or DSCP value, but how you map that to the internal
priority of the switch is up to you. Since DSCP can have 64 different values you
already need some sort of reduced mapping to the 8 queues used by the shaper.

The lower limit of what defines reasonable durations is that frames need to
still be able to pass through with little interruption. Too short and it will
start causing more problems that it solves. With too short gates it could result
in frames either not fitting in the gate and start encroaching on the next time
slot, or being preempted a lot if used with Frame Preemption.

The maximum latency for your requirements defines the upper limit of a single
gate's duration A low-priority gate cannot have a duration longer than the
maximum latency, otherwise the higher priorities has to wait too long for their
turn. The total cycle time has no theoretical upper limit, but at some point it
will be more worth to have it cycle back to the start instead of defining more
gates.

All gates have a guard band at the end of their duration. During the guard band
no new frames can be sent, it only allows already started frames to finish. This
is to avoid frames encroaching on the next time slot. To completely avoid it you
can set the guard band to the maximum size of a frame, 1518 bytes. This means
that if the frame started sending it will be guaranteed to finish before the
gate closes. However, this could end up wasting a lot of time when a frame
finishes very early into the guard band and it has to idle until the next gate.

```no-hl
|------------------|-------------|
|    Gate 1   | GB | Gate 2 | GB |
|------------------|-------------|
```

## Frame Preemption
Frame Preemption can be used in conjunction with Time-Aware Shapers to make
them more efficient. Frame preemption was covered briefly in the TSN
introduction post. A quick recap. It requires frames to be classified as express
or non-express frames. It allows non-express frames to be interrupted by express
frames to allow the express frame to send immediately.

When used with Time-Aware Shaper you apply the different Frame Preemption
options SetGateStates (`S`), Set-And-Hold-MAC (`H`), and Set-And-Release-MAC
(`R`) to the different gates. `S` does nothing with respect to Frame Preemption,
but is an indicator that the guard band needs to be longer before it starts. `H`
makes sure any frames from previous gate are preempted when the gate starts. `R`
allows non-express frames to send again. `H` allows the guard bands to be
reduced drastically because now they can preempt a frame when reached. It only
needs to add the extra CRC checksum and then it can move on to the next gate.
Shorter guard bands enables better bandwidth usage.

If you have multiple express gates (`H`) in a row then it won't be able to
preempt in preparation for the next gate, but then you also have bad design :).
