---
layout: mathpost
title: "Functions: a deep dive"
date: 2021-07-25
tags: ["math", "programming", "computer_science"]
categories: math
description: "Programming functions from a mathematical perspective."
---

<script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3.0.1/es5/tex-mml-chtml.js"></script>


In this post we will take a closer look at functions and some mathematical
concepts relating to them. This post assumes you are familiar working with
functions in some programming language and some mathematical knowledge of
functions as well (like knowing what \\(y = f(x)\\) means and what a set is).



## Terminology and notation

Before getting into the main topic I want to cover some terminology and
notation. Sets are denoted as an uppercase letter in math-style font like
\\(A\\). When I say that an element **maps** to another it is simply a way of
saying that some element \\(x\\), when given as argument to \\(f\\) will return an
element \\(y\\), or as an equation \\(y = f(x)\\), \\(x\\) maps to \\(y\\). A
**transformation** from \\(x\\) to \\(y\\). A function/mapping is simply a
transformation from one thing to another. One goes in, another goes out.

It is also good to know the mathematical notation for the types of a function.
\\(f : A \rightarrow B\\) represents a function \\(f\\) that takes a single
argument of type \\(A\\) and returns a value of type \\(B\\). To be more accurate,
\\(A\\) and \\(B\\) aren't types, but rather a set of possible values that can be
input/output. But in the world of programming we often represent them as types
like `int`, `string`, `float`, or similar. For example, the \\(log\\) function
could be written as \\(log : \mathbb{R}^+ \rightarrow \mathbb{R}\\), which means
all positive real numbers as input and all real numbers as output. Although in
the programming world it would instead be written as \\(log : \text{float}
\rightarrow \text{float}\\). \\(A\\) is called the **domain**. \\(B\\) is called the
**codomain**. If we want to be more exact we use the term **range** to indicate
all possible values that \\(f\\) can return. Which means that the range is a
subset of the codomain. For example, for the function \\(f(x) = x^2\\) we can say
it has the codomain \\(\mathbb{R}\\), but if you inspect the function you will
see that the range is only \\(\mathbb{R}^+\\), only the positive real numbers
since the function can never return any negative numbers.

## Determinism and the definition of a function

Going strictly by the mathematical definition we don't have any reference types
(pointers) and no `void` functions. A function must always return a value for
any element that is in its domain. Exceptions like values that will cause
division by zero or other undefined computations will not be in that domain and
are expected to not be put into the function. To be able to make any useful
arguments regarding a function we must also require it to be **pure**.

The concept of pure functions only exist in the programming world, because in
the world of math every function is pure. A pure function is one where the the
return value only depends on the arguments. There cannot be any side effects.
The function cannot print or write any values to external memory, and cannot
read any values from the outside. These are what we call side-effects,
inputs/outputs that are not the function arguments and return value. If we
allow side-effects then the function becomes inherently non-deterministic,
unpredictable. From here on when I say input I mean the arguments and output
means return value. The simplest pure function we can have is the "constant
function". It takes 0 arguments and returns the same value every time it is
called. Since we can't have any side-effects that is all a function with no
input can do. Below is an example of a constant function (written in Python).
As you can see, if we don't have any arguments there is no data to work with if
we aren't allowed side-effects.

```py
def pi():
  return 3.14159265359
```

This may seem restricting, but determinism in itself is a very useful property
for a function. The same input will always give the same output. It's very easy
to test as it doesn't depend on any state, which also makes it easier to debug.
If you have some logical mistake in a deterministic function then all you need
to do is find the mistake inside that function (assuming the input is correct,
otherwise the issue is elsewhere). If it is non-deterministic function then you
may need to look at all state that it is working with to find what goes wrong.
You may need to debug much more outside of the function in question to find
what leads to the invalid state.

If you don't care about the formal definition then just skip to the next
section. A formal definition is that a function \\(f : A \rightarrow B\\) maps
every element in a set \\(A\\) to some element in a set \\(B\\), and each
element in \\(A\\) can only map to a single element in \\(B\\). This means that
for any value \\(x \in A\\), \\(f(x)\\) must always be the same value. Or
expressed as a logical statement below: if \\(f(x)\\) returns two values
\\(y_1\\) and \\(y_2\\) from the same \\(x\\) then \\(y_1 = y_2\\).

\\( \forall x. x \in A. y_1 = f(x) \wedge y_2 = f(x) \implies y_1 = y_2 \\)

If the return values were different then that would contradict the definition
of a function and it would also break the purity and determinism. If \\(y_1\\)
and \\(y_2\\) are different for the same \\(x\\) then the function obviously has
side-effects.



## Injective, surjective, and bijective

An injective function is a function \\(f : A \rightarrow B\\) where no two
elements in \\(A\\) returns the same element in \\(B\\). This is a function that is
reversible because each value in the range has only one corresponding value in
the domain. But that is only true for the range. Every value \\(y = f(x)\\) can
be reversed to get back \\(x\\), but not every value in the codomain. The
codomain may be a superset of the range, so there may be elements in the
codomain that do not have any corresponding element in the domain. Some
properties that derive from this is that the sets of the domain and range must
be the same size, and the codomain must be equal or greater than the domain.

A surjective function is the opposite of an injective. All elements in the
codomain must be return values of some input to \\(f\\). Which means that the
range = codomain. But the domain can be larger than the codomain since multiple
elements of \\(A\\) can map to the same element of \\(B\\). There is no guarantee
that the elements in \\(B\\) can be reversed since there may be several values of
\\(A\\) that can give that output.

Bijective functions are functions that are both injective and surjective. When
we put those two together we get a function that is a one-to-one mapping
between the domain and codomain. It is always reversible in both directions and
you can always create an inverse function that gives back the original (usually
denoted \\(f^{-1}\\), where \\(f^{-1}(f(x)) = x\\)). Inverse operations can be
useful when you want to undo something you have previously done or when you
need to find out what the original was. For example, addition and subtraction
are inverses. If we have \\(f(x) = x + 5\\) then the inverse of that is
\\(f^{-1}(x) = x - 5\\).

While bijective functions have a clear use-case of inverse operations,
injective and surjective functions may be harder to find a good use for.
Although it can be something to keep in mind when programming as they have some
unique properties which you may be able to use for something.


## Chaining functions

When we have functions that always return values and have well-defined domains
and codomains then we can easily chain them. This is called function
composition. In mathematical notation it looks like this \\( g \circ f\\), which
simply means \\(g(f(x))\\). But to do this the functions must have matching
domains and codomains. If \\(f : A \rightarrow B\\) then we must have \\(g : B
\rightarrow C\\) to be able to chain them. So if \\(h = g \circ f\\) then \\(h : A
\rightarrow C\\) since it performs both \\(f\\) and \\(g\\). Composing functions
like this is very good for creating a long pipeline of transformations. And if
we stick to using deterministic functions then it becomes very clean looking
code and the different components get separated into distinct parts where one
returns what the next needs. When chaining functions it is important to keep
track on the domain and range of your functions. If \\(g\\) can return a value
that \\(f\\) cannot take as input then you have a problem.

The concept of chaining can be applied on reference types as well. It requires
every method to return `self` or `this` or whatever your language calls the
reference an object has to itself. So you could call methods like
`x.f().g().h()` and so on, where each method modifies the internal structure as
if those were the arguments. This is commonly seen in the builder pattern (C#
example below). The non-object-oriented equivalent of that is `h(g(f(x)))`,
where `x` could just as well just be an object that holds some variables. The
problem with determinism and purity in object oriented programming comes when a
method both modifies the internal state and returns a separate value. Because
at that point it has changed some state that is separate from the return value.

```csharp
HumanBuilder builder = new HumanBuilder();
Human human = builder.AddHead().AddBody().AddArms().AddLegs().Build();
```

There is nothing wrong with non-deterministic functions. Non-determinism is
required to make any interesting program. And a lot of object oriented
programming revolves around changing state. It just takes a different approach
than the mathematical side. Although I do encourage you to write as much
deterministic code as possible.



## Other types of mappings

Dictionaries, HashMaps, HashDictionaries, and the like are all mappings from
one set to another. The key is the input and the value is the output. And as
long as you don't modify them they are deterministic. Although modifying them
are often a key feature of using them. They may not be considered functions,
but they are definitely relations, a superset of functions. A relation is just
a mapping from one element to another, often denoted (1,2) when 1 maps to 2 (in
function notation: \\(2 = f(1)\\)). Although relations are often represented as
whole sets of mappings to indicate all possible relations like \\(\{(1,2),
(2,3), (3,4), (4,5)\}\\) to indicate a subset of the function \\(f(x) = x + 1\\)
for integers.

Switch statements are also a type of mapping, and a function, from some
variable value to a block of code. If that block of code is just a function
that returns its value then you have a mapping from a value to a function (C#
example below).


```cs
switch (x){
  case 1 : return f();
  case 2 : return g();
  default: return h();
}
```

Everything stated here extends easily to functions with multiple arguments or
multiple return values, usually denoted as tuples. Although deciding if such
functions are injective or surjective may become much harder. The notation for
such a function is \\(f : A \times B \rightarrow C \times D\\), where \\(A \times
B\\) means the Cartesian product of the sets \\(A\\) and \\(B\\). Meaning all
possible combinations of the elements of the two sets. When you have multiple
arguments the domain increases a whole lot in size, since now every element in
\\(A\\) can be paired with every element in \\(B\\). The total domain size becomes
\\(\vert A \vert \times \vert B \vert\\) (size of \\(A\\) multiplied by size of
\\(B\\)).


Functions and relations are everywhere in programming. In places you never
considered before. Even your browser is a mapping that takes a URL and returns
a webpage. Keep an eye out for them and see if you can use that knowledge to
write cleaner and better code, and maybe catch some bugs.







