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
published: true
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
features. The timestamped packets are intended to never touch any software on
their trip through the network since that adds considerable delay and jitter,
and the benefit of hardware timestamping dwindles. In which case using `ping`
may be enough precision.

If you are unfamiliar with timestamping I recommend checking out my post on [PTP
and timestamping methods]({{< ref 2023-04-05-ptp-intro-timestamping.md >}}).

[GitHub repository](https://github.com/cappe987/wiretime)


## Using Wiretime

Wiretime requires two interfaces, one for transmission and one for receival.
This can be the same physical port by creating two VLAN interfaces on top of the
port interface (note that they must be attached directly to the port and not
through a bridge as bridges cannot do timestamping). Ideally, Wiretime should be
used on a network switch that has multiple interface capable of timestamping.
For best accuracy the ports should use the same Physical Hardware Clock (PHC).
If they aren't using the same PHC they need to be precisely synced.

The packets will use a path that loops back to the transmitting switch. The
receiving port should be removed from the switch bridge to avoid flooding.
Packets are timestamped on transmission and receival and the difference is
calculated across several packets and the average is taken.

The most basic command looks like this
```sh
wiretime --tx eth1 --rx eth2
```

The following is an illustration of an example setup. Wiretime runs on SW1 and
transmits on one port and receives on another. The packet is switched in
hardware through SW2, and then back to SW1.
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

`-t, --tx <IFACE>`
Transmit packets on `<IFACE>`. Can be a VLAN or other interface,
as long as the physical port supports hardware timestamping.

`-r, --rx <IFACE>`
Receive packets on interface `<IFACE>`. Can be a VLAN or other interface,
as long as the physical port supports hardware timestamping.

`-p, --pcp <PCP>`
PCP priority. If VLAN is not set it will use VLAN 0.

`-v, --vlan <VID>`
VID to tag the packet with.

`-P, --prio <PRIO>`
Socket priority. Used to achieve egress QoS.

`-o, --one-step`
Use one-step TX instead of two-step.

`-O, --out <filename>`
Output data into file for plotting. Use when running Wiretime on a device that
does not have Gnuplot installed. The file can then be copied to another device
for plotting afterwards.

`-s, --pkts_per_sec <count>`
Amount of packets to transmit per second. Default: 100

`-S, --pkts_per_summary <count>`
Amount of packets to include in every output. Size of one *interval*. Together
with `pkts_per_sec` this determines how often it will show outputs. Default:
`pkts_per_sec` (meaning once every second). Maximum: 32768 packets due to the
PTP sequence number field used being 16 bits and Wiretime keeps two full
intervals active.

`--plot <filename>`
Plots the data using Gnuplot and exports as PDF. If -O is
not used it will create a temporary file for storing the data. The same plotting
settings also exists as a bash script in the repository.

`--tstamp-all`
Enable timestamping of non-PTP packets. On some NICs this will behave
differently than timestamping PTP packets only. Incompatible with `--one-step`.


## Example plot

Below is an example plot using one-step PHY timestamping taken over 110 seconds.
The packets are sent from one switch, through another, and back to the senders
receiving port. The total time spent on the wire is around 3500--4000
nanoseconds, or 3.5--4 microseconds.

![Image of one-step PHY timestamping measurement](/docs/img/phy-one-step.png)





