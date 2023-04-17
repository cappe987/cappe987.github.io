---
layout: post
title: Jekyll markdown lists that don't start on 1.
date: 2023-03-26
tags: ["misc"]
categories: misc
description: Custom properties of specific elements in a post
published: true
---

This is just a short note to myself and anyone who encounters the same issue.
While writing a post recently I wanted a numbered list that started with a number
other than 1. Frustratingly, Jekyll does not support this. Jekyll always start
lists with 1. I found this very inconvenient and tried to find a way around
it. One solution is inline HTML. But then you are restricted to writing lists
in HTML, and everything inside the lists needs to be formatted with HTML as
well, if you want italics or code blocks, etc.

As I found out, Jekyll supports adding custom classes, IDs, and properties to HTML
objects. To start my list at a different number I could simply do.
```md
{:start="5"}
1. First item
2. Second item
3. Third item
```

And the result is:

5. First item
6. Second item
7. Third item

Note that the `{:}` requires a blank line before it when styling a whole block,
but it can also be inlined to apply to elements within a text. Classes and IDs
can be added with `{:.myclass}` and `{:#myid}`. For more details on this I
refer you to the place where I found it: [Jekyll Tip: Adding Styling To Html
Output](https://digitaldrummerj.me/styling-jekyll-markdown/)

According to the CommonMark markdown specification the rendered list should
start with whatever the first number may be (within some restrictions, such as
it can't be negative and maximum 9 digits). The following numbers are
disregarded and will only count up from the initial list item. Refer to [5.3
Lists](https://spec.commonmark.org/0.30/#start-number) and examples
[#265](https://spec.commonmark.org/0.30/#example-265),
[#267](https://spec.commonmark.org/0.30/#example-267), and
[#268](https://spec.commonmark.org/0.30/#example-268).
