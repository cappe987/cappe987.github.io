---
layout: post
title: "tab-width: 8"
tags: ["programming"]
categories: programming
description: "
        One of the never-ending debates in programming. There is no right answer, but
        why not give it a try?
        "
date: 2026-07-31
---

One of the never-ending debates in programming, along with Vim vs Emacs. Neither
of which has any right answer, though these days we all know Vim keybindings are
the way to go. What tab-width should you use? Tabs or spaces? Infinitely many
variants exist, or probably at least five. No right answer exists, but I'd like
to argue some are wrong. Such as three-space indentation, or mixed tabs and
spaces (i.e., one indentation is four spaces, two indentations is one tab).
Let's just agree on that.

Many languages define their own formatting rules. In which case you should
follow that rule. Individual projects may also define their standard. With no
official rule for C, it is left to the author.

Comparing tabs and spaces, tabs have the benefit of being customisable. Anyone
can set whatever indentation they want. Spaces require everyone to use the same.
Customisation, however, leads to inconsistencies in the visuals. A six-level
indentation to someone using two spaces wide tabs is a total of 12 characters.
Someone using eight spaces-wide sees that as 48 characters, and code may require
horizontal scrolling to read. With my current setup, I can fit almost 100
characters on the screen, given I split my editor into two vertical windows.
Long function calls easily reach that limit even without much indentation. Code
should be easily readable without requiring side-scrolling or line-wrapping.

My first encounter with `tab-width: 8` was in the Linux kernel. An old project
following old coding practices. Doesn't mean it's not good. A larger tab-width
means you reach that max line length faster. I don't want to see six levels of
indentation; a well-established opinion from anyone talking about clean and
readable code. The tab-width helps enforce this. Especially for anyone using a
split-window setup like me.

Just like Vim keybindings are slowly winning the editor race, four spaces wide
tabs seem to be the default indentation of many editors today. Maybe give
tab-width eight a chance? Who knows, you might like it.

---

For anyone using an ultrawide monitor, some editors can set a line guide at a
character limit. Use this to avoid writing super long lines. Editors also often
show what row and column the cursor is currently at, and formatters can help
enforce line length.
