---
layout: post
title: "Accidental timetravel with timestamping"
date: 2023-04-20
tags: ["networks", "linux"]
categories: networks
description: While experimenting with timestamping I accidentally travelled back in time.
published: false
---

While playing around with timestamping and measuring with [Wiretime]({{< ref
"wiretime.md" >}}) I ended up accidentally running it on a preemptible traffic
class. The plan was to measure on an express traffic class while putting network
load on a preemptible traffic class, but I forgot the classification. This
turned into some interesting discoveries.

My first discovery was that it did not seem to timestamp. Huh? Why not? It seems
that timestamping on a preemptible traffic class was not possible. I tried
one-step. No change! Alright, instead of PHY, let's try MAC timestamping. Once
again, two-step: nothing. With one alternative left, MAC one-step, I decided to
try that as well.

To my surprise, that worked... kind of. It did timestamp the frame, but when it
got back it showed that the reception time, taken on the very same clock, was
earlier than the transmission time. How did the clock travel backwards? I'm not
running any time synchronization or other software that could modify the clock.
I still have no idea what caused this. But I also realized that running time
synchronization, which is the original purpose of hardware timestamping, is not
really a good idea on preemptible traffic classes. Time synchronization should
probably use high priority traffic to have as good precision as possible.
Preempting frames could delay them a lot.

Though, one solution could be to set the minimum fragment size for frame
preemption to be the maximum size of a PTP frame. In which case it cannot
preempt PTP frames because they are too small. But as for why it just doesn't
work, I have no idea. The exact same setup works just fine when using
express traffic classes. One theory I had for the MAC was that the timestamping
unit sits in the express MAC and not the preemptible MAC. But that can't be true
since it was able to do one-step timestamping. And the PHY, which doesn't have a
separate unit for handling preemptible frames, would not have this issue.

Lessons learned but mysteries left unsolved!
