---
layout: post
title: "History and future of my project: TSTest"
date: 2025-01-04
tags: ["misc", "networks"]
categories: misc
description: "
A brief history of how the project started, grew, and what I want it to become.
"
---

It's Christmas and New Year vacation, with no work and no other activities (aside from the festivities) it has given me some extra time to focus on a side project. This time my focus was on [TSTest](https://github.com/cappe987/tstest/). The project started 1.5 years ago by taking some code from the Linuxptp project, as well as the `timestamping` tool in the Linux kernel. `timestamping` provides a basic interface for interacting with the Precision Time Protocol (PTP) and Physical Hardware Clock (PHC) functionalities of the kernel. Linuxptp provides complete daemons for functional usage of the features. What I wanted was something in between. Not as barebones as `timestamping`, but enough control to test a single functionality at a time.

## The history

Initially, it was part of a collection of simple C programs I made for testing various network things (the rest of which are still in a private repository). At some point, I probably thought it fit to make it public in its own repository. Looking at the commit history I see it is likely when I added the second feature.

The first feature, which now exists under the subcommand `tstest pkt`, was sending and receiving PTP packets, and getting their timestamps. You could specify the packet type to transmit. This was helpful when figuring out the driver configurations for different packet types in different timestamping modes. Running `ptp4l` from Linuxptp did too much and it ran on timers so I couldn't just send one packet.

When the second feature came, the original functionality was moved into the subcommand `pkt`, and the new feature fell under the name `tstest extts`. **EXT**ernal **T**ime**S**tamp is when a PTP clock timestamps a pulse signal coming into the PHC, e.g. from a GPIO or PPS output elsewhere on the system. This command listens for EXTTS events on a PTP clock. Not much more to it.

Much later came the `tstest delay` command to independently run peer delay measurement as a server or client. The server responds to requests. The client sends requests and prints the measured peer delay.

## Recent work and future aspirations

Most of this development was done in 2023. 2024 has been a pretty slow year in terms of new features. I have plans to make it a proper testing tool with the `tstest check` command. It should configure different modes and test that it timestamps packets correctly. This is very much on hold. There is code for it, but it's incomplete, and never tested on hardware (only software timestamping). The idea is to run a looped cable (assuming the device has two PTP-capable ports*), send on one port, and receive on the other.

Recently I started on a new path, the subcommand currently known as `tstest tc` for testing transparent clocks. The idea started with wanting to measure the one-way time error introduced by a TC. There are complex commercial solutions for PTP performance testing, but it's helpful to have a CLI tool for the same job. Of course, a commercial solution is much more reliable. Using your own devices as a reference requires knowing that they are correct. The device running `tstest` must have good PTP accuracy and precision to ensure it doesn't introduce any inaccuracies.

The foundation for this is two synchronized ports, or two ports that run on the same PHC, that send packets back and forth, but now through a TC. The first implementation of this was for onestep E2E TC as that doesn't require any software involvement from the switch and is simple to calculate, send a Sync from `eth1` and receive on `eth2` and calculate the difference `RX - TX - correctionField` to find the error it introduces. However, to handle twostep, P2P, and boundary clock I saw the need for some major refactoring, which has been a lot of my work the past few days. Separate port handling, recording all information on each port, mapping the messages sent on one port to the ones received on the other, calculating the measurements, and making it modular.

After finishing a measurement the data can be saved to a file for further processing, such as generating graphs. However, the measurement device may not have software for it so the graphing is left to an external Python script using Matplotlib. I had never used Matplotlib before, only Gnuplot. But after some tinkering, I achieved pretty graphs and concatenated them as PDFs.

## Final words

The size of the TSTest project is starting to become significant. It has transitioned from a simple utility tool to something I'm passionate about working on. Even if I'm the only one using it. There's still a lot of work and refactoring to do.

I have a previous project called [Wiretime](https://github.com/cappe987/wiretime) which I used to measure the impact of QoS in networks. It works pretty well, but the code is quite messy and not very modular. I see the potential to include this functionality in TStest instead. At the core, this is exactly what `tstest tc` does, but it started from the other end. It's easier to extend the simpler TSTest, than to entirely refactor Wiretime which was designed and hardcoded with only one feature in mind.

---

*It is possible to create two VLANs on a single port and use those, and have a device on the other end swap the VLAN tag and send it back. This can be accomplished with Python Scapy: sniff on the port, check the VLAN tag, modify the VLAN tag, and send it back. PTP performance won't be good, but it works for protocol testing.
