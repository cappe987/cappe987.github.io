---
layout: post
title: How many ethernet ports are too many?
date: 2025-08-06
tags: ["networks"]
categories: networks
description: IEEE 1588 defines the field portNumber as a 16-bit unsigned integer.
---

Some network protocols need to keep track of which physical port is
which in a topology. PTP is one of those. Defined in IEEE 1588, it
specifies a field called portNumber. It is an unsigned 16-bit
integer. This means the limit for a single network switch is 65536
ethernet ports. Now, one could argue that 8 bits, 256 ports, is
enough. But it doesn't hurt to future proof and the next logical step
is 16 bits. Surely no one will ever make a switch with that many
ports!

But if someone makes a switch with over 4096 ports, and that switch
also needs to comply with IEC 62439-3:2021, it is up to the network
engineering team to ensure no more than 4096 ports are used.

> Since the four most significant bits of the portNumber must be
> "0000" for all clocks in the network, the number of ports
> per device is reduced to 4 096. The network engineering team is
> responsible for enforcing it. -- IEC 62439-3:2021

Let's pray that this will be enough.
