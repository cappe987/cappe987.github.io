---
layout: post
title: "Libcap utilities"
date: 2022-06-08
tags: linux
description: Some useful tools for working with Linux Capabilities
published: false
---



I recently learned about Linux
[capabilities(7)](http://man7.org/linux/man-pages/man7/capabilities.7.html) from
[this post](https://troglobit.com/2016/12/11/a-life-without-sudo/) by Troglobit,
a colleague of mine. It gives a good introduction to what it is and how to get
started. Go read it before continuing here. I thought I'd expand a bit on it
and some caveats that I learned when setting it up.

Capabilities are per-user and per-file (executable). Both the user and the file
needs to have the required capabilities to run. When adding the user
capabilities to `/etc/security/capability.conf` there should already be a
template there. The template is mostly comments, except for one line that says
`none *`. The config file works in a top-down manner. When you are given a
capability it cannot be overridden later in the file [DOUBLE CHECK]. `none *` is
a catch-all that says "assign no capabilities to everything that has not been
assigned". Any capabilities you try to set after that are ignored because it has
already set "none" there. Keep in mind that for this file to apply you must log
out and back in again.

To do a quick test if it worked you can simply do `su $USER` to log in to a new
shell. Run your command without sudo and see if it worked. You can also list
your capabilities by running `capsh --print` and looking at the `Current:`
field. It should match the `capability.conf` file.  For the capabilities to be
fully applied you must log out and back in of your graphical session (e.g.,
desktop environment).


https://adil.medium.com/run-your-applications-with-necessary-privileges-linux-capabilities-428e2c402f0b


