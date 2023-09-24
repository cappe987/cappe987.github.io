---
title: "Capmon"
description: "
A Linux capabilities(7) monitor. Monitor capability checks to find what a command requires. Then give yourself those capabilities to run without sudo.
"
date: 2023-04-15
showReadingTime: false
showDate: false
showDescription: true
hideMeta: true
published: true
---

Monitor when processes check `capabilities(7)` to find out what they require.
Run `capmon '<cmd>'` to track the capabilities it requires. It's important to not
run it with sudo since that bypasses certain checks. Let the command fail at the
first missing capability check and add that capability, then try again and see
if if fails on more. Rinse and repeat until command runs successfully.

If you are not familiar with capabilities can read [A simpler life without
sudo]({{< ref "2022-08-26-a-simpler-life-without-sudo.md" >}}).

[Capmon - GitHub](https://github.com/cappe987/capmon)

## Using Capmon

It is recommended to use Capmon without sudo, since running it with sudo the
provided command inherits the sudo properties and will bypass several checks.
Capmon requires `CAP_DAC_OVERRIDE` and `CAP_SYS_ADMIN`.

To use Capmon do
```sh
capmon '<cmd>'
```

For example:
```sh
capmon 'ip link netns add test'
```
It is recommended to enclose the command in quotes to avoid the shell from
doing any funny business with globbing or other special features. Capmon will
run the command with `/bin/sh`.

The output of the above command will be
```sh
[ip]
- [PASS] CAP_DAC_OVERRIDE
- [PASS] CAP_NET_ADMIN
```
because the `ip` command required the capabilities `CAP_NET_ADMIN` and
`CAP_DAC_OVERRIDE` for this particular task. Another example, `ip link set dev
tap0 up` only requires `CAP_NET_ADMIN`.

If the user didn't have the capabilities it would instead report `[FAIL]` on one
of the capabilities. If it failed on the first of the two then it may not even
show the second since commands often bail out as soon as they fail to do
something.

If a command is still failing even though Capmon doesn't report anything there
is the flag `-a` or `--all`. This changes the place where it listens to another
location which covers many more checks, some of which are not always necessary
and are allowed to fail. This is not the default mode as to not confuse the
user with a bunch of capabilities that usually will not matter.


## How it works

Capmon uses BPF tracepoints and fexit tracing to listen to two different events.

1. Capability checks (fexit)
2. Process starts (tracepoint)

(1) looks a the return value of the capability check. By default it listens to
the `ns_capable` and `capable_wrt_inode_uidgid` kernel functions. Most required
capability checks go through either of these two functions. But in case it
doesn't, the `--all` flag changes it to instead listen to the `cap_capable`. The
capability and the result is saved and mapped to the PID that did the check.

(2) looks at the PID of the parent process (the one who started the new
process) and if that matches with the PID of the command it is saved. Next time
a process starts it will look against all previously saved PID. This ensures
that any even subprocesses of subprocesses, and so on, are kept track of.

At the end it compares all saved PID (the process and its subprocesses) against
all capability checks done and takes the intersection. The output is the
capability checks done by the input command.

Capmon itself ignores `Ctrl-C` (`SIGINT`) so it is passed down to the monitored
program. This allows it to support interactive programs that are stopped with
`Ctrl-C`.

It currently does not handle orphan processes since it stops once the initial
command is done. To handle this there is monitor mode using the `--monitor`
flag. This mode does not run any command, instead it behaves similar to
`tcpdump` and can filter and output a summary based on PID or name.


