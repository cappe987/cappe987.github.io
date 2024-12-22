---
layout: post
title: "A simpler life without sudo"
date: 2022-08-26
tags: ["linux", "programming"]
categories: linux
description: "
Using Linux capabilities(7) to avoid using sudo, and using Capmon to figure out
what capbilities are required.
"
---

An incredibly underused but oh-so-amazing feature in Linux is *capabilities*.
Everyone should use it to make their lives simpler.

By default, a user does not have many permissions on a system. Some are granted
automatically through different means, such as reading and writing files in
your home directory. As developers, we may regularly have to reach for `sudo` to
allow us to do what we want. Writing our password over and over again, or
constantly forgetting to prefix your command with sudo. It can get tiring.

On the other end, you could do like ye olden days and start a shell as a
superuser; run everything with sudo. However, sudo was specifically invented to
not have users run everything as a superuser, as it is inherently a bad idea.
Using sudo gives you access to everything. Not using it gives you access to very
little. But what if there was a middle ground?

Enter *capabilities*. All of the actions that normally require sudo have one or
more capabilities associated with them. Sudo grants you all capabilities,
allowing for any kind of mayhem when running commands with it. However, you can
also grant yourself only some of these capabilities. It is assigned per user and
application. This means that to run a command that normally requires sudo
without it, both the user and the command must have the required capabilities.
This gives the bonus of safety, an application cannot do actions you explicitly
haven't given it access to. It also allows system administrators to give users
access to run certain applications without the need to give them sudo rights.

## Using capabilities

As mentioned above, capabilities are given to both users and applications. Let's
start with users. This is stored in the file `/etc/security/capability.conf`.
Edit the file and add a line like this but with your username.

```sh
cap_net_raw,cap_net_admin	casan
```

This gives the user `casan` the two capabilities `cap_net_raw` and
`cap_net_admin` and should take effect immediately. Next, we need some
application. Let's use the `ip` command. To find where the command is located we
can use `which ip`. An important detail here is that you can't give capabilities
to symlinks, so if a command is symlinked the capability must be given to the
actual executable file.

But before we add the capability, let's try doing a command without sudo. It
should fail with `ioctl(TUNSETIFF): Operation not permitted`.

```sh
ip tuntap add tap99 mod tap
```

Now add the capability `cap_net_admin` to the command.

```sh
sudo setcap cap_net_admin+ep /bin/ip
```

Try the previous command again and it should work. And just to clean up our mess
we can delete the newly created `tap99` interface with `ip link del dev tap99`
(which we can also do without sudo).

Now you know how to add capabilities to avoid using sudo. But how do we know
which capabilities a command needs? It can depend on which arguments you pass
the command, depending on what the arguments do. If you use the commands of `ip
netns` you need different capabilities than the example above. You can always
read the manpage
[capabilities(7)](http://man7.org/linux/man-pages/man7/capabilities.7.html) to
get a better understanding of the individual capabilities. But if you don't
fully understand how a command works it can be difficult to figure out. It can
also be the case of one command starting another subprocess, where the
subprocess is the one that needs the capability.

## Capmon: figuring out capabilities

Introducing [Capmon - a Linux capabilities
monitor](https://github.com/cappe987/capmon). A tool that monitors your process
and shows a report over which capabilities it looked for. You simply pass your
command as an argument to Capmon and it will execute it. But before you get
started, Capmon does require the capabilities `cap_dac_override` and
`cap_sys_admin`, running it with sudo does not work correctly because that
bypasses certain checks. Now that you've added those capabilities to yourself
and Capmon, let's try it out.

```sh
capmon 'ip tuntap add tap99 mod tap'
```

Assuming you did everything correctly, this should output the following text
indicating that the `ip` application accessed the `cap_net_admin` capability
successfully.

```sh
[ip]
- [PASS] CAP_NET_ADMIN
```

Now take what you've learnt here and use more commands without sudo.

### Some things to keep in mind

- If a command is failing but you are not seeing any FAIL output from Capmon,
  try running with the flag `-a`. This adds some additional monitoring points.
- It is recommended to use quotes around your command, otherwise dash-arguments
  arguments will be interpreted as arguments to Capmon.
- Commands that require multiple capabilities will usually stop and return an
  error on the first failed check. In this case, add the first capability, then
  run it again and it will fail on the second.




## Footnote

The title of this post is a homage to a blogpost by a former colleague who
taught me about capabilities and a ton of other things, which in turn inspired
me to create Capmon. You can read his post at [A life without
sudo](https://troglobit.com/2016/12/11/a-life-without-sudo/).


