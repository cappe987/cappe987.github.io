---
layout: post
title: "The Power of Makefiles"
<!--date: 2022-09-29-->
tags: programming
description: A little showcase of what Make can do
published: false
---

This is part 2 of a post I did on [boot.dev](https://boot.dev/) about
[Makefiles to improve your
life](https://blog.boot.dev/stories/makefiles-to-improve-your-life/). In this
post I will dive a bit deeper into what makes Makefiles so powerful.

# Variables
A life without variables? Not possible! They are in Make too and help avoiding
duplication. A basic use-case that is very often used when building C code is to
list both commands and arguments for the compiler as variables.

```make
CC = gcc
FLAGS = -Wall -Wextra
INCLUDE = -Iinclude/
FILES = main.c bits.c utils.c

all:
	$(CC) $(FLAGS) $(INCLUDE) $(FILES)
```
All parts of the command are encapsulated in variables depending on what type of
argument they are. Make also allows easy use of the shell when working with
variables. Instead of listing all C files the shell can be used to fetch them.

```make
FILES = $(shell ls *.c)
```

# Wildcards and internal macros `$@, $<, $^`

# Parallelism and ordered dependencies

# Programming in Make
Make is a Turing complete programming language. However, that does not mean it
is good at everything. I would put it in a similar situation, or even slightly
worse, as SQL. It *can* use it for everything, but it is certainly not made for
it. At the end of the day it is a build tool. It doesn't need all the
capabilities of a fancy all-purpose programming language, as long as it is good
at what it does.

The correct domain for Make is manipulating text. It has a bunch of [useful
functions](https://www.gnu.org/software/make/manual/html_node/Text-Functions.html)
for working with text. The targets in makefiles also depend on text. A lot can
be done by matching different rules as well. Any programming done in Make should
be done outside of targets. The indented commands belonging to a target are
interpreted as shell commands, not Make code. Make is part of the declarative
proramming paradigm. Anyone familiar with functional programming will recognize
how statements are handled. It is a bit reminiscent of Lisp since function calls
(and variabless) are accessed with `$(function arg1, arg2, ...)`. If-statements
and for-loops are functions too, `$(if condition, when-true, when-false)`. When
defining custom functions it is not really creating a function, but rather a
macro that has to be expanded like `$(call my_macro arg1, arg2, ...)`.

One domain where Make is completely lacking, and as I noticed is barely usable,
is numbers. It does not have support for arithmetics and needs to escape to the
shell to do that. When writing this post I decided to give Advent of Code an
attempt with Make. I managed to solve Day 1 Part 1, then gave up while trying to
do Part 2. It was not that I couldn't get the right answer. I could not get it
to not give me errors. Maybe some Make guru can do it, but I have decided that
at present time I cannot. I suppose this reinforces the old saying

> Just because you can doesn't mean you should




