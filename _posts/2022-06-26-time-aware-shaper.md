---
layout: post
title: "TSN: Time-Aware Shaper"
date: 2022-06-26
tags: networks
description: "Time Sensitive Networking and the 802.1Qbv standard"
published: false
---

Let's dive a little deeper into Time-Aware Shapers (TAS), specified in the
IEEE 802.1Qbv standard. For a light introduction go read my [intro to
TSN]({% post_url 2022-06-07-tsn-intro %}).

As mentioned in my previous post, TAS uses a hardware clock to keep a strict
schedule of which packet priorities can send when.

The shapers are applied on egress and each shaper has a list of time slots,
where each time slot specifies a `duration`, `operation`, and `gate_mask`. The
`duration` represents how long a gate stays open. The `gate_mask` specifies
which egress queues (gates) are open during that time. Multiple queues can be
open at the same time, at which point it treats it as regular Strict Priority
between those queues, i.e., higher priority goes first. `operation` will be
covered later. It can have the values `S`, `H`, and `R`. TAS can have a
theoretically infinite number of these time slots, also known as **gates**, but
in practice there will of course be a limit to what both the software and
hardware can support. The sum of the gates' durations defines the cycle time.
When it has iterated through all the gates it restarts with the first gate
again. 

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

- Frame preemption

- Seamless transitions

- Qcc to generate schedules

- Hardware layout. Lists and gate lists
