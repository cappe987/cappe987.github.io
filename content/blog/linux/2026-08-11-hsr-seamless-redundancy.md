---
layout: post
title: Seamless redundancy in networks
tags: ["linux"]
categories: linux
description: "
Redundancy without downtime is crucial in many industries. Try it yourself with
HSR in network namespaces.
"
date: 2026-08-11
---

Redundancy with zero downtime, at the cost of double the bandwidth. HSR and PRP
provides that for you. All traffic is duplicated to ensure that at least one
copy arrives even if a cable breaks. Many other protocols, like spanning trees,
requires reconfiguration when the topology changes.


## Setup

Let's start by creating some veth interfaces that we can communicate over. One
is put in a network namespace. ARP can be a bit wonky when both ends are in the
same namespace. 

Let's start by creating two namespaces and veth ports assigned to them. This
requires `sudo`, or `CAP_NET_ADMIN` + `CAP_SYS_ADMIN` capabilities for `ip`.
ARP can be a bit wonky if they are in the same namespace, so this is easiest.
Sudo also isn't required once inside the namespace.

```sh
sudo ip netns add ns1
sudo ip netns add ns2
sudo ip link add dev veth1 netns ns1 type veth peer name veth2 netns ns2
sudo ip link add dev veth3 netns ns1 type veth peer name veth4 netns ns2
```

Open two terminals, and attach in one for each.

```sh
sudo ip netns exec ns1 bash
```
```sh
sudo ip netns exec ns2 bash
```

In namespace `ns1` execute the following to set up an HSR interface with an IP address.

```sh
ip link set dev veth1 up
ip link set dev veth3 up
ip link add name hsr1 type hsr slave1 veth1 slave2 veth3 version 1
ip addr add dev hsr1 198.18.2.1/24
ip link set dev hsr1 up
```

And the same for `ns2`.

```sh
ip link set dev veth2 up
ip link set dev veth4 up
ip link add name hsr2 type hsr slave1 veth2 slave2 veth4 version 1
ip addr add dev hsr2 198.18.2.2/24
ip link set dev hsr2 up
```

If you instead wish to use PRP, add `proto 1` at the end when creating the HSR
interface. They use the same underlying principles.

The topology we have now looks like this.

```
    ns1               ns2
 198.18.2.1        198.18.2.2
+----------+      +----------+
|          |      |          |
|  +-veth1-+------+-veth2-+  |
|  |       |      |       |  |
| hsr1     |      |     hsr2 |
|  |       |      |       |  |
|  +-veth3-+------+-veth4-+  |
|          |      |          |
+----------+      +----------+
```


## Testing the redundancy

The `hsr1` interface owns the ports `veth1` and `veth3`. Any traffic sent on
`hsr1` will be duplicated and sent across both ports. Any packets received has
the first copy delivered upwards, and the second (if there is one) is discarded.
Pinging from `ns1` should now reach the IP of `hsr2` and get a reply.

```sh
ping 198.18.2.2
```

Break one link and see that the ping keeps going.
```sh
ip link set dev veth2 down
```

And bring it back up again.

```sh
ip link set dev veth2 up
```

Try the same with `veth4`. Try setting both `veth2` and `veth4` down at the same
time, now the pinging will stop.


## Theory of Operation

I already mentioned the basic concept, duplicate traffic. If one packet doesn't
go all the way, hopefully the other does. And hopefully someone can get out and
fix the broken cable before something else breaks. There are ways of combining
HSR and PRP to get more levels of redudancy, but that is out of scope for this
post.

HSR, High-availability Seamless Redundancy, is a ring protocol. Every device in
the ring must support HSR. A header tag is attached at the start of the ethernet
packet. Most important is the sequence number, a 16-bit integer counter for each
source MAC address the interface transmits. The counter increments for every
packet sent from the corresponding source MAC. This means duplicates are
identified by their source MAC + sequence number. If the receiver sees two
matching packets within a short timespan, it assumes the second one is a
duplicate and discards it. The counter wraps around and numbers can be reused.

Because HSR uses a header tag it requires every device in the redundant path to
support it. PRP, Parallel Redundancy Protocol, does away with that and instead
uses a trailer, a very similar tag that goes at the end of a packet. The trailer
contains a small checksum, to somewhat guarantee that the packet it sees is a
PRP packet, and not just part of a normal payload. PRP is not a ring protocol.
The two ports should instead go to a separate LANs, with the receivers also
having one port to each LAN.

Because the trailer makes it look like a normal packet, any kind of switch can
be used in between. It can be combined with RSTP within the LAN to provide
redundancy for less critical devices that don't support the PRP dual connection.


## Teardown

Exit the namespaces and run the following.

```sh
sudo ip netns del ns1
sudo ip netns del ns2
```
