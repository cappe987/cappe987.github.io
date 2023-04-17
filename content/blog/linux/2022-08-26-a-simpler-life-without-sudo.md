---
layout: post
title: "A simpler life without sudo"
date: 2022-08-26
tags: ["linux", "programming"]
categories: linux
description: Using Capmon to figure out what capabilities your program needs
published: true
---

A couple months ago a colleague showed me his post on [a life without
sudo](https://troglobit.com/2016/12/11/a-life-without-sudo/). In it he
demonstrates the elegant use of Linux
[capabilities(7)](http://man7.org/linux/man-pages/man7/capabilities.7.html). If
you aren't familiar with capabilities I recommend reading his post first. I
started using it myself and found it incredibly convenient. I would run sudo
many times per day before. This would usually be to do some network-related
activity such as sending raw packets or changing network interfaces. These I
know require the capabilities `CAP_NET_RAW` and `CAP_NET_ADMIN`. But once in a
while I come across something where I do not know which capability it uses.
Network namespaces was such a thing. Turns out it requires `CAP_SYS_ADMIN` and
`CAP_DAC_OVERRIDE`. 

To make my new life without sudo even simpler I wrote [capmon - a Linux
capabilities monitor](https://github.com/cappe987/capmon). It  allows you to
monitor the capability checks that Linux does, and is able to filter and
aggregate them for you.

## How it works

It makes use of kprobe-based event tracing. The kernel config
`CONFIG_KPROBE_EVENTS` exposes a debugfs (debug file system) that you can
interact with by reading and writing to files. It lets you set debug probes
(kprobes) on kernel functions and print out information when they are called or
returns. In the case of capmon it listens to calls to functions that do
capability checks and prints the argument `int cap` which holds an integer
representing the capability it is checking. It also prints the name of the
process calling it and its process id (pid). This all ends up in a log file at
`/sys/kernel/debug/tracing/trace_pipe` that capmon actively reads from when
data comes in. The data is parsed and presented in a more user-friendly manner.

It features three filter options: filter by process name, pid, or capability
being checked. Process name supports regular expressions. The filters can be
combined freely. Filters of the same type are treated as `OR`, while filters of
different types are treated as `AND`. Filtering is great, but one feature which
I think really helps is the summary mode. Sometimes there can be a lot of
output. The summary mode allows you to gather all checks by either process name
or pid. At the end it will print out which names/id's checked which
capabilities.

## How to use it
`capmon` itself uses `CAP_DAC_OVERRIDE`, in case you don't want to use sudo for
it. If you want to find the capabilities of a program you start by running
capmon. Possibly with some filters or flags. Now we will use summary mode to
find the required permission. For example:
```
capmon -s name
```
Then you run the program without sudo. Now you can either add the capability you
saw pop up in capmon, or stop capmon using \<Ctrl-C\> to see the summary mode. It may fail on
the first capability check and stop there. So you may have to add that
capability then run it again to have it fail on the next one.

## Issues
As of release 1.1 of capmon there are some issues with the design that I would
like to resolve in the future.

### What to monitor?
Right now it shows more capability checks than necessary, and sometimes it might
still not show all you want. This is because capability checks take different
paths through the kernel, though they all seem to converge to `cap_capable`. But
`cap_capable` is called a lot and for things you might not care about. I added
that as an extra flag `-a`. By default it monitors `ns_capable` and
`capable_wrt_inode_uidgid`. A lot of checks might happen due to capabilities I
think the user might have by default. For example, `CAP_SYS_PTRACE` is called a
lot when you run `htop`. Even though I never explicitly gave that capability.

### Interacting with kprobe events
The debugfs interface works fine for manual debugging. But it feels too unstable
to be used for an application. It uses a common output file and it could easily
break through manually touching the debugfs. Or even if some other application
wants to do a similar thing. They might send a clear-all command to the debufs.

I would like to rewrite this using libbpf, to write proper code that attaches to
the functions instead of sending raw strings to files.
