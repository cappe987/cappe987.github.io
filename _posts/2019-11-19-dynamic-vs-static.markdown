---
layout: post
title: "Static vs dynamic typing"
date: 2019-11-19
categories: types
---


# Static and dynamic typing explained 

> Static typing can find type errors reliably at compile time, 
    which should increase the reliability of the delivered 
    program - Wikipedia

Static type checking guarantees type safety, to a certain degree, 
without even running the program. A variable has one type and 
one type only. It can never change its type. This eliminates a 
lot of errors, and you can spend less time testing it. 

A language with dynamic type checking has its types checked during runtime. 
These languages often leave out type declarations in the code, leading 
to less code to read and write.
This adds extra overhead when running, and increases the likelihood 
of runtime type error. Since it only checks the types it encounters, 
it won't validate the types in any execution paths you don't test. 

The code snippet below contains two separate execution paths, 
and depending on what value `some_condition` holds, the `else` 
condition may or may not run. 

{% highlight python %}
if some_condition:
   print(1 + 1)
 else:
   print(1 + "1") 
{% endhighlight %}

Someone who has used Python may see that
the addition in the `else` path will throw a type error. 
A statically typed language would catch the error compile-time.
Python, however, has a dynamic type system and will 
not notice the type error if execution doesn't go down that path. 
Imagine the condition being something that evaluates to 
`True` 99% of the time. You could continue coding for a 
good while before noticing your mistake.

Statically typed languages, while type safe to a certain degree, can 
still contain dynamically typed parts. Languages that make use 
of inheritance (eg. C#, Java, C++) tend to mix static and dynamic typing. 
A variable of type A can also hold an instance of any subclass to A. 
This works because any subclass of A can do everything that A 
can do. Although it can't use the subclass' additional 
functionalities while assigned to a variable of the supertype, you can 
downcast the object to its actual type. 

When a variable contains an object of
a different type than declared we speak of actual type (the type 
of the object, possibly a subclass) vs. apparent type (the type of the variable). 
Here the dynamic part comes in. Because the actual 
type of the object may differ from the apparent type we 
can't know at compile-time if we can downcast. Different execution paths may 
lead to the variable containing a different subclass. 

Only when we know the actual type of the variable can we tell
if the code allows the downcasting or not. If not it usually 
results in a runtime error.

# Static typing

The snippet above shows the type signature for the function 
`map` in Python. We can see that it wants a function and an iterable for 
input (according to hopefully good variable names). 
Without knowing the meaning of map you can't tell 
what we should pass to it. You could somewhat assume what counts as 
iterable, but it doesn't classify exactly what defines an iterable. 
Looking at the function parameter we can't tell anything about 
what type the argument should have.


{% highlight c# %}
IEnumerable<R> Select<T,R>(IEnumerable<T>, Func<T,R>)
{% endhighlight %}

Here we have the type signature for the same function in C#. 
`T` and
`R` represents two generic types which 
it has to match in the type signature. 

For the first argument you can pass it any C# class that implements 
the interface   IEnumerable&ltT&gt` of any type 
`T`. As opposed to Python, it clearly states what defines 
an iterable.

`Func<T,R>` represents a function 
that takes a value of type `T` and returns a value of 
type `R`. This means that if we pass in a list of 
integers, we must also pass in a function that takes an integer 
as input, and we will receive an `IEnumerable` of 
type `R` as output. The compiler will complain if 
we pass it anything that doesn't match.

Static typing tends to make languages more verbose when explicitly 
stating the types, but not necessarily. Some languages have a 
strong type inference. 


{% highlight haskell %}
map f [] = []
map f (x:xs) = (f x) : map f xs
{% endhighlight %}

The snippet above shows a simple implementation of `map` in Haskell. 
By analyzing how I've used lists, list operators, and functions, 
it can infer the type signature `(a -> b) -> [a] -> [b]`.


# Dynamic typing


# My experiences


# To write about
Mixed languages, inheritance downcasting requires dynamic.
Testing dynamic languages in REPL (complete code not needed).
