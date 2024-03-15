---
layout: post
title: "Useful commands I use"
date: 2023-07-31
tags: ["misc", "linux"]
categories: misc
description: "
A list of commands that I like to use
"
published: true
---

I thought it would be fun to look at all the different commands I use. I took a
peek into my Zsh history and extracted just the commands (without any
arguments). Below is the command I used. It also removes anything that starts
with `.`, `~`, and `/` to avoid local scripts and binaries. My original intent
was to publish the whole list, but it's long, and over half of it is just
misspelled commands and a lot of aliases. And frankly, most of it is not very
interesting. Instead, here is a curated selection just for you. I tried to
include some lesser known commands/uses since other similar lists tend to have a
huge overlap. I may revisit this post in the future to add more commands.

```bash
history | sed -e 's/^[[:space:]]*//' | cut -d' ' -f3 | sed -e 's/^[\.\/~].*//g' | sort | uniq
```

<hr></hr>

## `capmon`
I'm starting this list with a shameless plug of my command, and it only
happened to be first due to alphabetical order ;). Run it with a
command to check which Linux kernel capabilities the command requires. E.g.
`capmon "tcpdump -i eth0"`. As someone who loves and uses capabilities, this is
very helpful. Check it out [here]({{< ref "capmon.md" >}}).


## `errno`
Because I can never remember what the different exit codes mean I use a command
to check it. Just `errno -l` is enough, but I prefer to reorder the output to
make it easier to read:

```
errno -l | awk '{ printf("%s %s %s\n", $2, $1, substr($0,2)); }'
```

## `cloc`
Count Lines Of Code does exactly what it says. Counts how many lines of code you
have in different languages and how much of it is comments or blank lines, and
displays it in a pretty table. Check it out
[here](https://github.com/AlDanial/cloc).

## `rg`
Ripgrep is an awesome program for recursively searching directories for some
text. It's quite well known, but I had to include it here because it's essential
to me. Check it out [here](https://github.com/BurntSushi/ripgrep).

## `fd`
Like Ripgrep, this is another incredibly useful utility tool for searching, but
for files rather than inside files. It is an improved version of the standard
Linux command `find`. Check it out [here](https://github.com/sharkdp/fd).

## `delta`
A modern diff viewer with a pretty output and syntax highlighting. I use this
as the pager for `git diff`. Check it out
[here](https://github.com/dandavison/delta).

## `nautilus`
This is the standard file explorer for Ubuntu and probably many more distros. If
you would like to open a directory with the file explorer from the terminal
(rather than navigating to it via the GUI) you can run this command with the
desired path. E.g. `nautilus .` to open the current directory.

## `python`
Now this may look stupid, but I wanted to list it here because whenever I need a
calculator I open a terminal and start the REPL. Even though I rarely write
actual Python code.

## `rofi`
A pretty alternative to `dmenu` for creating interactive and searchable lists
and selecting an item. Check it out [here](https://github.com/davatorium/rofi).

## `reuse`
Reuse is an initiative by the Free Software Foundation to standardize how
code licenses are indicated in projects and source files. Along with it exists
the command of the same name. My mostly used is `reuse lint` to check
if my project is compliant.

## `rifle`
This command comes along when you install the `ranger` command (a TUI file
explorer). It opens a file with the correct (as good as it can) program. There
already exists a program called `xdg-open` that does this, and which is included
on most distros. But I find `rifle` to be much better at picking the right
application.

## `tac`
`tac` is the reverse of `cat`. And that's just what it does. Any input to `cat`
is just spat out the same way it came in. `tac` reverses the order of the lines.
I often use this inside Vim by selecting some lines, then running it from Vim
with `:!tac`. (Note: placing an exclamation mark at the start of a Vim command
runs it as a shell command).


---

Added 2024-03-15:

## `btop`
A better and prettier alternative to the more common `htop`. Check it
out [here](https://github.com/aristocratos/btop).

## `unshare`
Preferably with the arguments `-n -r` to start a separate network
namespace and as root. This allows running commands as root even
though you might not have root access. Certain actions are obviously
not possible even as this root. But it can allow you to do testing
of applications that requires root. For me it's relevant for network
applications.
