---
layout: post
title: "TSN: Frame Preemption"
date: 2023-04-21
tags: ["networks"]
categories: networks
description: NULL
published: false
---

802.1Qbu and 802.3br together form the standard known as Frame Preemption,
created by the TSN Task Group as a way to allow high priority packets to get to
their destination as quickly as possible.

As the name implies, this technology allows frames to be preempted. Meaning it
is stopped partway through. The standard divides traffic classes into two
groups: express and preemptible. By default, all traffic classes are considered
express. Frames egressing on an express traffic class, also known as express
frames, have the possibility to preempt a preemptible frame that is currently
transmitting, within some limitations. This allows the express frame to start
egressing earlier, rather than waiting for the other frame to finish egressing.
The preempted frame that was sent is called a fragment. And the remaining part
of the frame is another fragment.

One of the limitations is minimum frame size. A frame cannot be smaller than 64
bytes. Since frame preemption splits a frame into two a frame smaller than 128
bytes cannot be preempted as that results in one of the fragments being less
than 64 bytes. Though the minimum fragment size can be increased if you wish for
larger frames to also not be preempted.






