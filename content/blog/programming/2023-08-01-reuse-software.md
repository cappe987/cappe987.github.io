---
layout: post
title: "Licensing and the REUSE Software initiative"
date: 2023-08-01
tags: ["programming"]
categories: programming
description: "
Code licensing and copyright is tricky. The REUSE Software initiative by the
Free Software Foundation provides standards and tools to make it easier.
"
published: true
---

> **Disclaimer:** I am not a lawyer. Please consult with a lawyer if you have
> any doubts regarding licensing and copyright.

## Licensing

Why do we license open-source code? Why is it not enough to just make it
publicly available? Because all code that is not explicitly licensed falls under
the default copyright laws, meaning that the authors of the code own everything
and it may not be used in derivative work. If the authors work for a company it
is typically the company that owns the work since it was done on their dime, and
if the code is proprietary then there is no need to license it. Licensing is
strictly required when you want others to be able to use the code.

In GitHub's guide to licensing, they make it clear that this is the case:

> You're under no obligation to choose a license. However, without a license,
> the default copyright laws apply, meaning that you retain all rights to your
> source code and no one may reproduce, distribute, or create derivative works
> from your work. If you're creating an open-source project, we strongly
> encourage you to include an open-source license.

-- [GitHub - licensing a repository](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository)

When starting a new project you do not have to choose a license immediately. It
can be added down the line when you have decided the goal of your software, but
until then you as the author retain full copyright. A license can also be
changed down the line; the only caveat is that you need the permission of all
copyright holders in the project. If many people have already contributed to a
project it would take all of them agreeing on the license change. Keep in mind
that changing the license will only affect the code as it is when you add the
new license. Any previously released iterations of the code will remain under
the license with which it was released. This could be the Git history (unless
you choose to completely rewrite the history) or anyone who downloaded it.

A license should be picked according to how you wish your project to be
distributed. Two popular open-source licenses are MIT and GPLv2. MIT allows
anyone to do anything with the code as long as the copyright and license notices
are preserved. GPLv2, which is famous for being the license used by the Linux
kernel, requires any modifications or derivative works to be made available
publicly. This prevents anyone from making proprietary changes.

If you are struggling to choose a license take a look at
[choosealicense.com](https://choosealicense.com/).

For a more rigorous explanation,
[opensource.guide/legal](https://opensource.guide/legal/)
has some good but still quite easily digestible content.

## REUSE Software

Code licensing is tricky, and it gets even trickier when you want to copy code
from other places to use in your code. What license some code uses may not be
immediately obvious. GitHub does display the license of a repository, but only
if it is placed in a way where GitHub is set to look for it. Far from all
projects follow their conventions. And even then, it only displays one license.
Projects can be licensed under multiple licenses depending on file type or
where the code was taken from. Even a single file can have sections of code
that fall under a different license. Dual licensing is another possibility that
allows you to choose which of the listed licenses to redistribute the code
with.

[REUSE](https://reuse.software) was created by the Free Software Foundation
Europe (FSFE) and aims to simplify handling code licensing by providing a
recommendation for how licensing should be done, as well as a tool to apply and
check licenses. It uses the [SPDX](https://spdx.dev/) standardized methods for
license and copyright of code. When a project is compliant with REUSE anyone
can easily check the copyrights of a file.

REUSE requires licensing all files to be compliant, except for any files listed
in `.gitignore` since they will never be included in the distribution of the
source code. The default method of licensing is to have a header in each file
that looks like this, using the comment style of the language corresponding to
the file extension.

```sh
# SPDX-FileCopyrightText: 2019 Jane Doe <jane@example.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later
```

The year and contact address may be omitted, but the name of the copyright
holder must always be included. If there are multiple copyright holders they
should all be listed individually. The license is indicated by an identifier
from the [SPDX Specification](https://spdx.org/licenses/).

For files that can't contain a license header (configuration files, images,
etc.) there are other ways. The documentation lists three methods for licensing
a file.

1. Placing tags in the header of the file.
2. Placing tags in a .license file adjacent to the file.
3. Putting the information in the DEP5 file.

To get started with REUSE you can install their tool and run `reuse init` in a
project. This will ask for a license and create the `.reuse/dep5` file. To
quickly add a license header to all existing files use the command `reuse
addheader`. To download a copy of all licenses used in the project use `reuse
download --all` (remember to edit it to contain the year and copyright holder
names, some licenses will have a placeholder where you should write it). To
check if your project is compliant use `reuse lint`. It is also a good idea to
add this to your CI pipeline, to avoid a badly licensed version of the
repository being distributed. Check out their website for full details on how to
install and use it.

I believe that REUSE has a bright future and I encourage you to use it
in your projects too. Let's improve the world of open source together, one
project at a time.






