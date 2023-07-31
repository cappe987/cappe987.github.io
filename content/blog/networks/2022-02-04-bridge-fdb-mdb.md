---
layout: post
title: "Network bridge forwarding and learning"
date: 2022-02-18
tags: ["networks", "linux"]
categories: networks
description: "Bridge forwarding of unicast and multicast in software and hardware"
published: true
---

A network switch has multiple ports to send and receive data on. To manage this
there is a component called "bridge" inside it. In Linux the bridge is defined
as a network interface, but it it can also be offloaded to hardware (at least
parts of it). The bridge is responsible for connecting different networks with
each other. A packet coming in on one connection has the possibility to go out
on any of the other bridged connections.


## Forwarding Database (fdb)
The Forwarding Database (fdb) stores the information about which bridged
connection a data packet should use depending on what the destination is. An fdb
entry needs to store the MAC address of the known destination and which
connection it should use to reach that. The connection is specified as an
interface, e.g., `eth3` or `vlan3`. When a packet arrives at the bridge the MAC
address will be inspected and matched to the fdb. If an entry is found it will
be forwarded to that interface. If none is found it is treated as unknown and
will be flooded to all ports of the same bridge (with the exception for any
ports that have flooding disabled).

Hopefully, the flood will result in the destination responding to the packet,
sending a reply back to the source. When the reply passes through the bridge it
sees which interface it arrived on and will save that in the fdb for next time.
Now packets have passed through the bridge from both devices and it has learned
which interface each destination is on. Next time they communicate the bridge
will find the entries in the fdb and forward the packets correctly.

Show the contents of the fdb in Linux
```sh
bridge fdb show
```

## Ageing
To avoid the fdb filling up with old entries a bridge can use *ageing*. It
keeps count of how many seconds has passed since each MAC address sent a packet
through the bridge; the counter is reset when a packet from that MAC address
enters the bridge. When the age reaches a set threshold it will be removed from
the fdb. For example, if a device stops responding to requests it will never
refresh the age and the fdb entry will eventually be forgotten since the device
is no longer considered part of the network.

What if you want to have a device that only listens to requests? Easy! You can
get around the ageing by setting a static fdb entry. These entries will never
age, they stay there until you say otherwise.

Add a MAC address to be forwarded to the specified interface. To make it static
you simply add `static` at the end
```sh
bridge fdb add <MAC> dev <INTERFACE>
```

## Multicast database (mdb)
The kernel also stores a database of all the multicast groups, which can be seen
if you run
```sh
bridge mdb show
```

For multicast it will create a entry when it gets an IGMP Join message. It
creates a entry for that group and marks the port that it arrived on. The goal
of multicast is to be able to send one message to multiple recipients. Which
means that the mdb must store all ports that are in the group, and then remove
them when they leave. This is typically stored in a port masks. For a switch
with 8 ports, where ports 2 and 4 are in the group, it could look like this
`00001010` (represented by the second and fourth bit). This indicates the
second and fourth port are in the group. When all ports eventually leave the
group it can remove the entry.

## Hardware offloading
Sometimes you want a bit higher performance. For those times you can use a
specialized hardware circuit for network switching. You get less load on your
CPU and higher throughput because the packets are switched directly in the
hardware and never touches the CPU. One drawback of this is that the hardware
only has the features it was built with. If you ever lack some feature you
can't simply write some code for it. But it usually comes with at least some
common features, such as its own fdb and mdb that are stored in its own
internal memory.

The fdb and mdb are stored in a table with fast lookup to quickly switch the
packets. The table might look something like this (simplified, it will usually
contain more information, e.g., age and if it is static or not)
```no-hl
-------------------------------------------------
|        MAC        | VLAN | TYPE | DESTINATION |
|-----------------------------------------------|
| 00:00:00:00:00:01 |  1   |  UC  |      2      |
| 00:00:00:12:ad:fd |  2   |  UC  |      5      |
| 01:00:5e:01:02:03 |  2   |  MC  |      1      |
-------------------------------------------------
```
The type indicates Unicast or Multicast. The unicast entries points at the port
it should send the packet to. Multicast, on the other hand, points to an index
in another table. This is where the port mask is stored.

Entries to this table can be added if the device driver supports it. Then an
entry will be added to both software and hardware, since it goes through
software first. All multicast addresses are added through software because that
is where the IGMP protocol is handled. Though, some entries may exist in
hardware only. This happens when the hardware learns unicast entries.

These are all things the bridge manages, whether it is a software defined bridge
,like the one in Linux, or if it has been offloaded to a hardware circuit. This
has been a little summary of what I have learned at work recently. Thanks for
reading!

