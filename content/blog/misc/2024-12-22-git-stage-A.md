---
layout: post
title: "Don't use 'git stage -A'"
date: 2024-12-22
tags: ["misc"]
categories: misc
description: "

Don't stage and fire away your commit. Take your time reviewing your changes.
"
published: true
---

This is a follow-up to my earlier post [Don't use 'git commit
-m']({{< ref "2023-07-15-git-commit-m" >}}).

Another common "anti-pattern" in standard Git usage (in my opinion, I
have no data to back this up). Just like with `git commit -m "msg"`, I
see that using `git stage -A` to stage all modified files is a common
practice amongst Git beginners. Or it's friend `git stage .` to stage
all files in the current (usually project root) directory.

> Note: `git add` is just an alias for `git stage`.

So what's the problem with this? Well, it stages all changes made. Are
you 100% sure you want all those changes? You don't know until you've
looked at them. Look through the Git diff to see all changes you've
made. Maybe you discover something you missed. Perhaps a leftover
debug print? A file you accidentally created or auto generated?

Ideally you should use a proper Git client. That makes it easier to go
through the changes, browse the code, and even stage parts of a
file. To achieve the best possible commits and commit history you
should carefully look through what you are committing. No one wants to
see a bunch of commits like "Fixed copy-paste mistake", "Removed debug
print", etc., because you were careless.

Obviously, mistakes happen anyway. Even with multiple people reviewing
your code. But let's all put in a little extra effort to make
reviewing code and reading Git history a more pleasant experience
