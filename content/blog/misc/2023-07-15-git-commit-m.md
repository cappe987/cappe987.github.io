---
layout: post
title: "Don't use 'git commit -m'"
date: 2023-07-15
tags: ["misc"]
categories: misc
description: "
Commit messages should be detailed and carefully written. Take your time.
"
published: true
---

I often see `git commit -m "My commit"` as a beginner example of how to create
commits. It is a simple way to  quickly create a commit with a short
explanation. My issue with it is that it teaches you to write short commit
messages. You only fit so much in the terminal before it starts wrapping around
and getting hard to work with, and you can't do any proper formatting. Granted,
there may be cases where a short text is enough to explain the commit. I,
however, don't believe this should be your default approach.

A good commit explains why something was done and why it was done in that
particular way. Looking at the Git history, `git log` and `git blame`, is
essential in any large codebase. It sucks looking at a commit that introduced
some change and all it says is "Changed X to Y because Z". Why did Z require
this change? Was Z a bug? If so, what caused the bug in X and how did it
manifest? What benefits does Y have? New features may need to contain some
general information on what the commit as a whole does.

## Using your editor

When not using `-m` Git defaults to using an editor to open it as a file. The
editor to use is defined in your `.gitconfig` file
```
[core]
	editor = nvim
```
or simply through `git config --global core.editor nvim`. Replace `nvim` with
whatever editor you wish to use.

The editor opens it as a file where you write the commit message. When you are
done, save the file and close it. This causes the commit to finish.


## The benefits of editors

Using your editor allows you to carefully think through your commit message
before saving and closing it. But the main benefit is that it can be formatted
into title/body texts. On top of that, it can also be used to add lists or
ASCII art to explain the commit. As an example, I'm going to use a commit I
recently made to an open source project.

```no-hl
ptp: Parse major and minor version correctly

In IEEE1588-2008, the lower 4 bits of the field were defined as the PTP
version, and the upper 4 bits were marked as reserved. As of the 2019
version the upper 4 bits are defined as PTP minor version. Previously,
the whole byte was assumed to be the version by Tcpdump, resulting in
PTP v2.1 being parsed as v18 and not printing the rest of the
information.

With this commit the version is parsed correctly and the packet is
displayed as v2.
```

By leaving an empty line before the second paragraph it creates the separation
of title/body. The first line becomes the title, the rest becomes the body. When
viewing in short form (e.g. on GitHub commit history) it only shows the title
and you have to click the three dots to expand the body. And if the title is too
long it gets truncated and the rest ends up in the body anyways. To make it easy
to browse keep your title concise at a maximum of 80 characters so the whole
title is shown. Most editors show the column number of your cursor somewhere on
the screen (usually at the bottom).

In the title, I give a short explanation of what the commit does. In the body, I
give a longer explanation of why this happened, what the resulting bug was, and
why my change is what it is. For general examples of good commit messages, I
refer you to the Linux kernel. They have a high standard on commits that are
accepted, and rightly so due to the immense size of the codebase and the rate
at which it changes.

As for how it looks on GitHub, here is both the title-only view and the full
commit view.

![GitHub title only](/img/commit_title.png)
![GitHub full commit](/img/commit_body.png)

As a final note, I would like to add that, though I always write my commits in
my editor, I am nowhere near as rigorous as the above example when it comes to
my personal projects. But as a project becomes larger and more serious the Git
history needs to be taken more seriously as well. Have the mindset right from
the beginning, and you will be able to do it properly when needed.
