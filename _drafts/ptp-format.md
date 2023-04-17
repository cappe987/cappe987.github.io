---
layout: post
title: PTP packet formats
<!--date: 2023-04-05-->
tags: networks
categories: networks
description: Documentation of PTP packet formats
published: false
---

<style type="text/css">
pre > code {
      display: block !important;
      line-height: 1.3rem !important;
      font-size: 1.3rem !important;
}
</style>

The IEEE 1588 standard defines a couple different PTP packets used for
different purposes. What they all have in common is the normal ethernet header
and the PTP header. Here I will illustrate what they look like.

```
┌────────────┬────────────┬──┐
│    DMAC    │   SMAC     │ET│
└────────────┴────────────┴──┘
```
The normal ethernet header consists of 6 bytes of destination MAC address, 6
bytes of source MAC address, and 2 bytes of ethertype to identify the protocol
of the data following it. Together they constitue the minimum valid ethernet
frame.

Offsets:
- 0: DMAC
- 6: SMAC
- 12: EtherType


After that comes the PTP header. When you have a PTP packet the EtherType will
be `0x88f7`.



