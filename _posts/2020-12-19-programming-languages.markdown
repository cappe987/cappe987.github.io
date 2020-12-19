---
layout: post
title: "What programming languages are worth learning?"
date: 2020-02-26
categories: ""
published: false
---

There exists many programming languages out there. But a lot of them have many similarities. Today I will discuss some points you should consider when choosing a new programming language, as well as give some suggestions of my own. Note that this applies only when learning a language for the sake of learning. When picking a language for a serious project you should pick the one that fits best for the situation, and the language best for a specific situation is a trade-off between languages you know well and languages that makes the project easier. But I'm not here to talk about that. I will talk about what to consider when you try to become a better programmer.

# Categories to choose from
There are some general categories we can choose from when picking a language. We can start to consider the paradigms as the categories. [Wikipedia](https://en.wikipedia.org/wiki/Programming_paradigm) mentions the two largest categories as *imperative* and *declarative*. Each of which has 2 and 3 subcategories. 

- Imperative
  - Procedural
  - Object Oriented
- Declarative
  - Functional
  - Logic
  - Mathematical

Each of these 5 subcategories require a different mindset and thought process when using. Some languages known as multi-paradigm languages are made to let you use several paragidms, although they generally favor one. For example F#, JavaScript, and Python all support both functional and object-oriented programming, although F# favors functional and the other two favor object-oriented. And in my opinion, learning a paradigm in a language where it's not the main focus doesn't give you the full experience of it. While JavaScript and Python supports a lot of techniques from functional programming, it still lacks certain things that are commonplace in functional-first languages. And while F#, which supports object-oriented programming to be compatible with C#, has all the object-oriented techniques, it's just not the same since the syntax and language structure wasn't intended for it. So when you learn one of these 5 paradigms, pick a language where it is the main paradigm.

Of course languages inside these paradigms can differ a lot. For example different language families. Languages that were heavily inspired by another language shares even more, while a language in a completely separate family may only share some things. Next we will take a look at some different language families inside the different paragidms. Languages that are multi-paradigm I will classify to their main paradigm.

# Imperative languages
Procedural and object-oriented programming has a lot of overlap, and that the parts that overlap are what classifies the languages as imperative. Imperative means that the languages works by modifying state, it executes one line at a time and the state for the next line is dependent on the previous line. An example of modifying state is this: `x = x + 1` modifies the variable `x`. If-statements and while- and for-loops are iconic imperative features. 

One major family here is the statically typed family where we have C# and Java with very verbose syntax and makes use of inheritance and other features that we today consider object-oriented. C syntax can also look very similar, since the imperative parts of them look the same, but C doesn't have any object-oriented features, and is therefore different. While you can quite easily write C# code in C-style, the opposite is only possible to a certain degree (you can emulate object-oriented in C using function pointers, but you can't emulate inheritance). And C also has a different use-case. It's much lower level than C# and Java, since you must manually manage any memory on the heap. I consider C# and Java to be in the same class of languages, hence you should only learn one. If you know C# then you won't gain much from learning Java. C on the other hand is a different class and you can definitely aim to learn along with C# or Java.

Another family of the imperative family is the scripting languages. Interpreted and generally dynamically typed. Here we have languages like Python, JavaScript, Bash. Scripting is usually used for smaller tasks and doesn't require the same structure as an industrial application in C# or Java. Although nowadays developers are using Python and JavaScript for this anyways (JavaScript is often paired with static typing tools like TypeScript or Flow). The benefit of scripting languages is that you require less planning to get started and the code is easier to change later on. In a language like C# or Java you have to write out a lot of types, doing some changes requires lots of changes everywhere. In Python or JavaScript you don't write out the types and you only need to change the parts of the code that actually matters, but the drawback is that there is no type system that tells you if what you're doing is right or if you forgot to change something. I like to think of them as prototyping languages, you quickly throw something together to see if it works. 

Bash is, unlike Python and JavaScript, not object-oriented. While many developers still write Python and JavaScript in a non object-oriented manner, Bash doesn't even support objects. And this procedural approach, where Python and JavaScript can also work, is useful for very short programs that do one simple thing. The main use of Bash is on Linux to write short scripts to do something like run a backup or change a setting. Here the interpreted and dynamic nature is to its benefit. You don't need to recompile whenever you make a little change, and you don't need to place any binary in an folder. You just write the script and run it. I don't think Bash is ever used for anything larger than simple automation scripts. But if you are using Linux then learning at least some Bash is almost essential, since even the command line runs Bash (or similar shell languages).

Lastly we will talk about Smalltalk. The original object-oriented language as Alan Kay imagined object-oriented programming to be. This is not what we consider object-oriented today, not like C#, Java, or Python. Smalltalk works by message passing between objects. I don't know much more about Smalltalk since I've never used it, but it's definitely on my list of languages to learn. I want to see how what Alan Kay envisioned the paragdigm to be. 

Of course these aren't the only imperative languages, but it's what I wanted to cover. See [this post]({% post_url 2019-11-21-dynamic-vs-static %}) for more talk about static vs dynamic typing.

# Functional
Haskell, F#/ML, Lisp

# Logic
Prolog

# Mathematical
Wolfram