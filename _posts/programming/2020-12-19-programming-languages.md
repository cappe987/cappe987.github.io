---
layout: post
title: "What programming languages are worth learning?"
date: 2020-12-19
tags: programming
categories: programming
published: false
---

There exists many programming languages out there. But a lot of them have many similarities. Today I will discuss some points you should consider when choosing a new programming language, as well as give some suggestions of my own. Note that this applies only when learning a language for the sake of learning. When picking a language for a serious project you should pick the one that fits best for the situation, and the language best for a specific situation is a trade-off between languages you know well and languages that makes the project easier. But I'm not here to talk about that. I will talk about what to consider when you try to become a better programmer.

> A language that doesn't affect the way you think about programming, is not worth knowing - *Alan Perlis*

# Categories to choose from
There are some general categories we can choose from when picking a language. We can start to consider the paradigms as the categories. [Wikipedia](https://en.wikipedia.org/wiki/Programming_paradigm) mentions the two largest categories as **imperative** and **declarative**. Each of which has 2 and 3 subcategories. 

- Imperative
  - Procedural
  - Object Oriented
- Declarative
  - Functional
  - Logic
  - Mathematical

Each of these 5 subcategories require a different mindset and thought process when using. Some languages known as multi-paradigm languages are made to let you use several paragidms, although they generally favor one. For example F#, JavaScript, and Python all support both functional and object-oriented programming, although F# favors functional and the other two favor object-oriented. And in my opinion, learning a paradigm in a language where it's not the main focus doesn't give you the full experience of it. While JavaScript and Python supports a lot of techniques from functional programming, it still lacks certain things that are commonplace in functional-first languages. And while F#, which supports object-oriented programming to be compatible with C#, has all the object-oriented techniques, it's just not the same since the syntax and language structure wasn't intended for it. So when you learn one of these 5 paradigms, pick a language where it is the main paradigm.

Of course languages inside these paradigms can differ a lot. For example different language families. Languages that were heavily inspired by another language shares even more, while a language in a completely separate family may only share some things. Next we will take a look at some different language families inside the different paradigms. Languages that are multi-paradigm I will classify to their main paradigm.

# Imperative languages
Procedural and object-oriented programming has a lot of overlap, and that the parts that overlap are what classifies the languages as imperative. Imperative means that the languages works by modifying state, it executes one line at a time and the state for the next line is dependent on the previous line. An example of modifying state is this: `x = x + 1` modifies the variable `x`. If-statements and while- and for-loops are iconic imperative features. 

One major family here is the statically typed object-oriented family where we have C# and Java with very verbose syntax and makes use of **inheritance** and other features that we today consider object-oriented. Object-oriented programming means to model your code in terms of objects with behavior. Objects have private fields to represent their state and objects communicate with each other through calling each other's methods. C syntax can also look very similar to C# and Java, since the imperative parts of them look the same, but C doesn't have any object-oriented features, and is therefore different. While you can quite easily write C# code in C-style, the opposite is only possible to a certain degree (you can emulate object-oriented in C using function pointers, but you can't emulate inheritance). And C also has a different use-case. It's much lower level than C# and Java, since you must **manually manage memory** on the heap. I consider C# and Java to be in the same class of languages, hence you should only learn one. If you know C# then you won't gain much from learning Java. C on the other hand is a different class and you can definitely aim to learn along with C# or Java.

Another family of the imperative languages is the **scripting languages**. Interpreted and dynamically typed. Here we have languages like Python, JavaScript, Bash. Scripting is usually used for **smaller tasks** and doesn't require the same structure as an industrial application in C# or Java. Although nowadays developers are using Python and JavaScript for this anyways (JavaScript is often paired with static typing tools like TypeScript or Flow). The benefit of scripting languages is that you require less planning to get started and the code is easier to change later on. In a language like C# or Java you have to write out a lot of types, doing some changes requires lots of changes everywhere. In Python or JavaScript you don't write out the types and you only need to change the parts of the code that actually matters, but the drawback is that there is no type system that tells you if what you're doing is right or if you forgot to change something. I like to think of them as prototyping languages, you quickly throw something together to see if it works. 

Bash is, unlike Python and JavaScript, not object-oriented. While many developers still write Python and JavaScript in a non object-oriented manner, Bash doesn't even support objects. And this procedural approach, where Python and JavaScript can also work, is useful for very short programs that do one simple thing. The main use of Bash is on Linux to write short scripts to do something like run a backup or change a setting. Here the interpreted and dynamic nature is to its benefit. You don't need to recompile whenever you make a little change, and you don't need to place any binary in a folder and you always have the source code. You just write the script and run it. I don't think Bash is ever used for anything larger than simple **automation scripts**. But if you are using Linux then learning at least some Bash is almost essential, since even the command line runs Bash (or similar shell languages).

Lastly I want to mention Smalltalk. The **original object-oriented** language as Alan Kay imagined object-oriented programming to be. This is not what we consider object-oriented today, not like C#, Java, or Python. Smalltalk works by message passing between objects. I don't know much more about Smalltalk since I've never used it, but it's definitely on my list of languages to learn. I want to see how what Alan Kay envisioned the paragdigm to be. 

Of course these aren't the only imperative languages, but it's what I wanted to cover. You can also read [this post]({% post_url programming/2019-11-21-dynamic-vs-static %}) if you want to learn more about static vs dynamic typing.

# Declarative 
Declarative programming is usually stateless. Each computation only depends on the values given to it. This takes inspiration from mathematics where the output of a function only depends on the input, and the output is always the same given the same input. In functional programming this is called a **pure** function, a function that behaves like the mathematical definition of a function. Now, most functional languages don't uphold this to the fullest, but the goal is to have as many of your functions as possible pure. A pure function can easily be tested as it doesn't depend on the context in which it is used. 

Complete purity in a language would also require that no IO (input/output) is done, as those are impure actions. Which makes it sound like a completely pure language is useless. And it sort of is. Haskell is one of the first languages that aimed for this. Every function must be pure, but thanks to **laziness** you can postpone the evaluation to the end of the program, and thanks to **monads** you can chain the IO so actions happen in the right order. Haskell also introduces the do-notation for monads, that lets you write almost imperative-like code, while still keeping the code functional and pure. The more I learn about Haskell the more it seems like Haskell programmers aim to code in imperative-style. Haskell is also very **inspired by mathematics** and takes many concepts from it.

Next up we have the ML (Meta Language) family, where F# is the most recent addition. They use a bit different syntax from Haskell, but in general very similar. They are both statically typed with great type inference so you don't even have to write out the types. F# allows IO to be done anywhere, no restrictions. But other than this you can code F# in a somewhat similar style, although F# doesn't take the mathematics part as far. F#, being part of the .NET family, is also fully interoperable with C# and is therefore gaining traction in the industry.

Now we're done with the statically typed languages. The next family is very old, older than C, and even one year older than COBOL. It's the Lisp family. Created in 1958 and has since split up into many different dialects. Lisp is mostly famous for its extensive use of parentheses and its prefix-only notation. But it has incredible strength in that you can modify it as you want. Linked lists is the most prominent data structure in Lisp because even Lisp itself is created through lists. The name LISP stands for "LISt Processor". Because the language itself is made up of lists it means you can easily manipulate the source code, which in turn lets you create your own syntax using **macros**. Lisp is also the language that were originally used for developing AI and machine learning. But recently Python has come along and taken the spot for the most popular language for that. The most popular Lisp dialect today is Clojure. 

Sticking to the dynamically typed languages we have Erlang. Erlang was made to be a language with focus on **concurrent programming**. The purpose of it was to be a language for telecommunications for the Swedish company Ericsson. They needed a language which could easily handle a lot of requests without failing. And if one call fails it can't crash everything. Instead it can just crash that specific process and start up a new process again. It can also do updates without restarting the program, or even stopping a phone call. After an update any new processes will be started with the new version, while the old processes stay on the old version until they end. Each process is a separate entity that can communicate by passing messages to each other. These properties also makes it **highly scalable**. Another newcomer on the scene is Elixir, which also uses the BEAM VM that Erlang is built upon.

As for logic and mathematical programming, I don't really have any experience with them. But I am definitely curious to try them out. Mathematical languages like Wolfram supports **symbolic representations of expression**. So writing an expression like `x+5` is completely fine, leaving the `x` as a variable. `x+5` is a valid return value. While most other languages would complain that it's a function and you need to give a value to `x` before getting a result. From that it can then manipulate that variable as fits when more operations are applied. Maybe I multiply it with another `x` and get `x^2 + 5x`. You can also apply that `x` and get a final result, or you can just treat it as a function of `f(x)`. And to just mention a logic language, Prolog is the one I've had my eyes on to learn some day. 

A little side note. SQL (Structured Query Language) also falls into the declarative programming paradigm. It's considered a domain-specific programming language and is used to query databases. Although today they tend to also support some procedural programming.

Another side note. Proof assistant languages like Coq are made to help prove mathematical theorems. They also belong to the declarative family.


# What to learn?
As I mentioned in the beginning, many languages share a lot and learning similar languages doesn't contribute much to your overall knowledge. You will want to learn a different language that changes the way you think. 

`C`: I think everyone should learn C to understand how things work under the hood. Maybe Rust can be included here as well.

`C++ | Java | C#`: Learn one of them. Many other modern languages can probably also be placed here.

`Python | JavaScript`: Popular for scripting. Definitely useful but not for larger projects, in my opinion. Many other modern languages can probably also be placed here.

`Haskell | F#`: Haskell is a bit more of a deep-dive, so if you know Haskell you probably won't gain much from learning F#. But Haskell is also considered much harder to learn.

`Clojure`: A language from the Lisp family to teach you about them.

`Erlang | Elixir`: To learn a bit about their way of concurrent programming.

`Wolfram | Matlab`: In case you are interested in programming with mathematics.

`Prolog`: To learn about logic programming.

If the language you are interested in isn't in this list, try and see which category it fits into to decide whether it's worth learning or not.
