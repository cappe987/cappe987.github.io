---
layout: post
title: "Vim Fugitive notes for myself"
date: 2024-01-12
tags: ["misc"]
categories: misc
description: "
A quick guide to using Vim Fugitive
"
published: true
---

Fugitive is an amazing plugin for Vim. It integrates a lot of Git functionality
into the editor. Part of it is that you can just run the commands from inside
git like `:G commit`. But it offers so much more and I want to document how to
use some of those features. Mostly for my own sake because I can never remember
them when I need them, but I hope it can help others as well.

## :Git

This shows the `git status` list of files. If you want a vertical view you can
use `:vertical G`. A file can be staged or unstaged with `s` and `u`.

The files can be opened to view the full diff. `=` toggles the
view. `>` (open) and `<` (close) can also be used to only open/close it instead
of toggle. In the diff view you can stage individual hunks with `s` and unstage
with `u`. `o` will open the file at  the location under the cursor.

`X` can be used to discard a change (either a whole file or the hunk under the
cursor).


## Diffsplit

Pressing `dd` (horizontal) or `dv` (vertical) opens a diff split where you can
see the modifications and alter them. By going into visual mode and running
`:diffput` you can stage individual lines rather than hunks. This also makes it
easier if you want to save part of a line for the next commit. Copy the line,
change one version to the "first commit" version, and keep the other line for
the second version. Then use diffput to stage only the first version. Then
delete the version you just staged. Now you have staged part of a line. This can
be useful for example when you have implemented some functionality but deem it
should be two separate commits, one that introduces the base functionality and
another that adds some more complex arguments.

Note that you should only modify the right/bottom file of the split, as that is
the one that reflects your current state. The other reflects how it looked
before your changes.


