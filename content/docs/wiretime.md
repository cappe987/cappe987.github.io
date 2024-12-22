---
title: "Wiretime"
description: "
Measure the time a packet is on the wire accurately using hardware timestamping. Useful for measuring the impact of traffic congestion and QoS.
"

date: 2023-04-17
showReadingTime: false
showDate: false
showDescription: true
hideMeta: true
---

<style type="text/css">
pre > code {
      display: block !important;
      line-height: 1.3rem !important;
      font-size: 1.3rem !important;
}
</style>

Measure the time a packet is on the wire accurately using hardware timestamping.
This is useful for measuring the impact of traffic congestion and testing QoS
features. The timestamped packets shouldn't go through any software
on their trip through the network since that adds considerable delay
and jitter, and the benefit of hardware timestamping dwindles. In
which case using `ping` may be enough precision.

For those unfamiliar with timestamping, check out this post on [PTP
and timestamping methods]({{< ref 2023-04-05-ptp-intro-timestamping.md >}}).

[GitHub repository](https://github.com/cappe987/wiretime)


## Using Wiretime

Wiretime requires two interfaces, one for transmission and one for reception.
This can be the same physical port by creating two VLAN interfaces on top of the
port interface (note that they must attach directly to the port and not
through a bridge as bridges can't do timestamping). Ideally, use
Wiretime on a network switch that has more than one interface capable of
timestamping. For best accuracy the ports should use the same
Physical Hardware Clock (PHC).  If they aren't using the same PHC they
need to be precisely synced.

The packets will use a path that loops back to the transmitting
switch. The receiving port have a different untagged VLAN than the
transmitting port, or removed from the bridge completely, to avoid
flooding. Wiretime timestamps packets on transmission and reception,
and calculates the difference across several packets and outputs an
average time.

The most basic command looks like this
```sh
wiretime --tx eth1 --rx eth2
```

The following is an illustration of an example setup. Wiretime runs on SW1 and
transmits on one port and receives on another. SW2 forwards it in
hardware, and then back to SW1.

```
    ┌───────┐
    │       │
┌───▲─┐   ┌─▼───┐
│ SW1 │   │ SW2 │
└───▲─┘   └─▼───┘
    │       │
    └───────┘
```

### Flags

`-t, --tx <interface>`
Send packets on `<interface>`. Can be a VLAN or other interface,
as long as the physical port supports hardware timestamping.

`-r, --rx <interface>`
Receive packets on interface `<interface>`. Can be a VLAN or other interface,
as long as the physical port supports hardware timestamping.

`-p, --pcp <PCP>`
VLAN Priority Code Point (PCP). If VLAN isn't set it will use VLAN 0.

`-v, --vlan <VID>`
VID to tag the packet with.

`-P, --prio <priority>`
Socket priority. Used to achieve egress QoS.

`-o, --one-step`
Use one-step TX instead of two-step.

`-O, --out <filename>`
Output data into file for plotting. Use when running Wiretime on a device that
doesn't have Gnuplot installed. Then copy it to another device for
plotting afterward.

`-i, --interval <milliseconds>`
Interval between packets. Default: 1000.

`-b, --batch_size <count>`
Amount of packets to include in every output. Outputs the average time of all
packets in the batch. Default: 1.

`-S, --software_tstamp`
Perform software timestamping instead of hardware timestamping.

`--plot <filename>`
Plots the data using Gnuplot and exports as PDF. If `-O` is
not used it will create a temporary file for storing the data. The same plotting
settings also exists as a bash script in the repository.

`--tstamp-all`
Enable timestamping of non-PTP packets. On some network cards this will behave
differently than timestamping PTP packets only. Incompatible with `--one-step`.


## Example plot

Below is an example plot using one-step PHY timestamping taken over 110 seconds.
The packets sends from one switch, through another, and back to the senders
receiving port. The total time spent on the wire is around 3500--4000
nanoseconds, or 3.5--4 microseconds.

![Image of one-step PHY timestamping measurement](/docs/img/phy-one-step.png)





