---
layout: post
title: "The day Make started crashing"
date: 2022-09-17
tags: ["programming", "linux"]
description: The last thing you want is for your build system to crash
published: true
---

This is a short story from `$DAYJOB` about my discovery and investigations of
an issue with the build system.

One day when building our code I suddenly got a segmentation fault when
building. An odd occurrence. I could not recall any changes to the build system
and checking the Git log I could not find any changes that would affect it. It
got even more mysterious as I went back in the Git history and would still have
the crash. I managed to narrow the issue down to one package which was being
built slightly differently than our other packages. Still, it didn't make sense
why it was failing.

The weirdest part of all this was that it was failing *between* two steps in the
build process. I added debug prints to the build system and I could see that it
finished the configuration step, but never reached the start of the build step.
I did not dig deeper into the build system here, as it is very complex Makefile
code. At this point, I knew there was some issue with Make. It output a core
dump upon crashing, so my next step was to take a look at that core dump. Find
out how it is crashing.

The core dump led me to a function called `func_filter_filterout`, which had a
loop that looked like this (shortened):
```c
while ((p = find_next_token (&word_iterator, &len)) != 0) {
	struct a_word *word = alloca (sizeof (struct a_word));

	*wordtail = word;
	wordtail = &word->next;

	word->str = p;
```

The crash would occur on the last line, but the key here is the function call to
`alloca`. It allocates memory similar to `malloc`, with the difference that the
allocation happens on the stack. This allows the memory to later be freed
automatically when the function exits. Reading the manpage
[alloca(3)](https://man7.org/linux/man-pages/man3/alloca.3.html) we can find
```
BUGS
       There is no error indication if the stack frame cannot
       be extended. (However, after a failed allocation, the
       program is likely to receive a SIGSEGV signal if it
       attempts to access the unallocated space.)
```

This is exactly what was happening. When printing the `word` address in the code
above I could see the address going up and down a lot (indicating it was
allocating for a while, then freeing and the function being called again). When
it reached the point where Make would crash I noticed the address increasing
continuously for a while and eventually crashing.

Curious as to why it was stuck in a seemingly infinite loop, or as it turns out,
just a very long one I changed my print to output `p`, the strings being
iterated over. The output showed Make variables for *many* packages, and many
we did not use. The packages were available for selection in the build system
but were not selected and it did not make sense why Make would iterate over them
when building a completely unrelated package. It did not do this iteration at
all when building other packages.

For some reason, Make would start iterating over all variables. I did not delve
further into this right now. I switched focus. Why did it start happening now?
Why was it never an issue before?

It didn't take too long for me to realize that a couple of weeks prior I had
upgraded Ubuntu on my work laptop from 21.04 to 22.04. Could they have upgraded
the Make version? Nope, Make 4.3 was released about 3 years ago and has not had
a new release. I talked to a colleague who was still on Ubuntu 21.04 and we both
had the Make 4.3. He sent me his Make binary for me to test. Surprisingly,
it works fine. Make 4.2.1 from Ubuntu 18.04 also works fine. It is not the
environment that is the issue. Something with the Make version shipped with
Ubuntu 22.04 is different. Well, maybe Ubuntu has some internal patches to Make
that introduced the bug? Let's try building Make 4.3 from source!

CRASH! The issue exists on the original release too?! Had Ubuntu fixed this
previously and now removed the fix? Are there differences in how it's built?
Even more questions I have yet to find an answer to.

Testing it with upstream Make did not cause the crash, but a lot has been
refactored since the last release of Make.

At this point, I turned away from chasing Make. At least using upstream works
fine. Being forced to build with tools from older Ubuntu versions would be awful
in the long run. It could end up with the build system using a Docker container
with Ubuntu 21.04 to build it for many years in the future.

I turned my attention back to the "faulty" package in our build system. Since it
was never really handled in an ideal way I decided to dig into that instead,
resulting in the package being split up and treated the same as every package
should be treated in the build system. 

Only after doing this did I discover this piece of Make code: `$(.VARIABLES)`. I
realize I should have looked closer at this code earlier, but at a glance the
code around it didn't do anything groundbreaking. It turns out this is a special
variable in Make that holds all other variables' names, and it was being
iterated over. 

I still have not found out why it suddenly became an issue on Ubuntu 22, but at
least I found what caused the issue. This journey has been a very interesting
and educational one. I learnt a lot about our build system and Make in general.
Time well spent!




