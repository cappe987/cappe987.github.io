---
layout: post
title: "Type inference with Hindley-Milner W algorithm"
date: 2020-02-26
tags: ["computer_science"]
categories: computer-science
description: "A demonstration of the Hindley-Milner W Algorithm in F#."
published: true
---

## Introduction
The W algorithm developed by J. Hindley and R. Milner is used to infer the types of a programming language where no types have been explicitly written. Several functional languages today use this kind of inference, for exampel F# and Haskell (although Haskellers still like to write out the types). The method works by assuming everything is a different generic type. The types of any pre-existing functions and any constants will be known before starting. So if there is a `0` in the code then that is an integer, `0.0` is a float, `[]` is a generic list.

## Finding the types

Types with an apostrophe before them means they are generic. A type is written with the syntax `variable_name : variable_type`.

We begin with a simple example. Below we have the identity function written in F#. It takes in an element and returns back the same element.

```fsharp
let id x = x
```

To calculate the types of this function we start by setting all unknown values to a generic type.

```fsharp
x : 'a
id : 'b -> 'c
```

The variable `x` has the generic type `'a` and the function `id` has the generic type of `'b -> 'c`. Because the input of the function is `x` and `x` has the generic type `'a` then the function input must also have the same type.

```fsharp
x : 'a
id : 'a -> 'c
```

The only possible output of this function is also the value of `x`. Thus the return value of the function must also be `'a`.

```fsharp
x : 'a
id : 'a -> 'a
```

And now we're done with that function. All values have been reduced to the same type. There are no further reductions to be done. The identity function has the type `'a -> 'a` because it will always return the same value it is given.

## A more complicated example
Below we have a function of which we do not know any of the types for.

```fsharp
let rec myfunc f xs =
  match xs with
  | []    -> []
  | x::xs -> f x :: myfunc f xs
```

We start by finding the types of all our constants and pre-existing functions and then giving a generic type to all our unknowns.

```fsharp
[] : 'a list
(::) : 'b -> 'b list -> 'b list
f : 'c
x : 'd
xs : 'e
myfunc : 'f
```

We can see that the parameters for `myfunc` are `f` and `xs`. Therefore `'f = 'c -> 'e -> 'g`

```fsharp
f : 'c
x : 'd
xs : 'e
myfunc : 'c -> 'e -> 'g
```

To start figuring out what the types are we can start by looking at the `match` statement. It matches on `xs` and the first pattern it suggests that it is of type `'a list`. The second pattern is a deconstructing pattern with the cons operator. Because of the `::` operator that means `x : 'b` and `xs : 'b list`, and the return value of the `::` operation and the second pattern match is therefore `'b list`. We can therefore say that `'e = 'a list = 'b list`, which in turn implies that `'d = 'a = 'b`.

```fsharp
f : 'c
x : 'a
xs : 'a list
myfunc : 'c -> 'a list -> 'g
```

Now there's only `'c` and `'g` left to figure out. We'll start with `'g'`. The return value of the first pattern match is an empty list `'h list`. Note that this is the second empty list we use and it is not guaranteed to be the same type as the first. Same goes for the `::` operator. The second pattern match returns the result of the `::` operation, which we'll call `'i list`. If the cons operator is to work on its arguments the left side must be `'i` and the right side must be `'i list`. Therefore myfunc must return an `'i list`. And since the only other return value of myfunc is `'h list` we can draw the conclusion that `'g = 'h list = 'i list`, which implies `'h = 'i`. Since we said earlier that `x : 'a` and the left input to `::` is `'h` we know that `f : 'a -> 'h`.

```fsharp
f : 'a -> 'h
x : 'a
xs : 'a list
myfunc : ('a -> 'h) -> 'a list -> 'h list
```

And then we fix it up a little by using only the first letters of the alphabet.

```fsharp
f : 'a -> 'b
x : 'a
xs : 'a list
myfunc : ('a -> 'b) -> 'a list -> 'b list
```

The final type of `myfunc` is `('a -> 'b) -> 'a list -> 'b list`. Any experienced functional programmer should now see what function it is, if they didn't already see it the second they saw the function definition. It is of course the famous `map` function, or more specifically the `map` function for lists.


## Introducing a type error
Now lets say we instead have the same function but a `::` switched out for a `+`.

```fsharp
let rec myfunc f xs =
  match xs with
  | []    -> []
  | x::xs -> f x + myfunc f xs
```

The plus operator has the type `(+) : 'num -> 'num -> 'num` where `'num` symbolizes a generic number type (eg. int, float, double). This would mean that `f : 'a -> 'num`. But the returning value of `myfunc` can't be a `'num` because the first case of the pattern match says it's an `'h list`. Now we have reached a type error and compilation can stop here. This code will not compile because the types for `+` doesn't match.

## Exercise for the reader

```fsharp
let exercise l =
  match l with
  | []    -> 0
  | x::xs ->
    if x > 0 then
      x + exercise xs
    else
      exercise xs
```
