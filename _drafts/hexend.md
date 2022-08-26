---
layout: post
title: "Hexend - Send raw hex packets"
date: 2022-08-26
tags: networks programming
description: A tool I made for sending raw hex packets
published: false
---

In my daily work I sometimes want to copy and modify raw packets as hexdumps. I
will usually copy a hexdump from Wireshark or Tcpdump. Though, some times I
have even written packets from scratch.

There are plenty of tools out there for building and sending packets. Two good
ones I have used are Nemesis and EasyFrames. They provide many options for
creating different types of packets. But sometimes you just want full freedom.
One thing I didn't manage to do with these two were to easily craft packets of
certain length when debugging an issue related to packets that were not
32-bit-aligned at the end. Maybe I could have done this by adding raw data to
the payload. But I found it easier to just look at the raw hex to see what I
was sending.

I did not find any complete project that did this. I spent a lot of time
googling. I found an easy way to send raw hex data in Python on StackOverflow
that I used for a bit. But when I decided to make it into a proper application
I wanted it in C. The reason being that I might want to use it in an embedded
enviroment, where Python is not available. I also considered if Bash or any
other common shell commands could do this, but nothing that I came up with.
Most did not support raw packets. Otherwise, it would have been really sweet to
have it as a simple shell script.

