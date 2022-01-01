---
layout: post
title: "Static vs dynamic typing"
date: 2019-11-21
categories: ""
tag: programming
description: "Comparing static and dynamic typing and my experiences and opinions."
published: true
---


## Static and dynamic typing explained 

> Static typing can find type errors reliably at compile time, 
> which should increase the reliability of the delivered 
> program - Wikipedia

A statically typed programming language checks that the types of everything matches. If something doesn't match, the compiler stops and displays an error. This guarantees type safety to a certain degree, without even running the program. A variable has one type and one type only. It can never change its type. This eliminates a lot of errors, and you can spend less time testing it. 

A language with dynamic type checking has its types checked during runtime.  These languages often leave out type declarations in the code, leading to less code to read and write.  Checking during runtime adds extra overhead when running, and increases the likelihood of runtime type error. Since it only checks the types it encounters, it won't validate the types in any execution paths you don't test. 

The code snippet below contains two separate execution paths, and depending on what value `some_condition` holds, the `else` condition may or may not run. 

{% highlight python %}
if some_condition:
   print(1 + 1)
else:
   print(1 + "1") 
{% endhighlight %}

Someone who has used Python may see that the addition in the `else` path will throw a type error.  A statically typed language would catch the error compile-time.  Python, however, has a dynamic type system and will not notice the type error if execution doesn't go down that path.  Imagine the condition being something that evaluates to `True` 99% of the time. You could continue coding for a good while before noticing your mistake.

Statically typed languages, while type safe to a certain degree, can still contain dynamically typed parts. Languages that make use of inheritance (eg. C#, Java, C++) tend to mix static and dynamic typing.  A variable of type A can also hold an instance of any subclass to A.  This works because any subclass of A can do everything that A can do. Although it can't use the subclass' additional functionalities while assigned to a variable of the supertype, you can downcast the object to its actual type. 

When a variable contains an object of a different type than declared, we speak of actual type (the type of the object, possibly a subclass) vs. apparent type (the type of the variable).  Here the dynamic part comes in. Because the actual type of the object may differ from the apparent type, we can't know at compile-time if we can downcast. Different execution paths may lead to the variable containing a different subclass. 

Only when we know the actual type of the variable can we tell if the code allows the downcasting or not. If not it usually results in a runtime error.

## Static typing

Statically typed languages tend to have better code completion.  With your text editor correctly set up you can get red squiggly lines under a lot of what would result in a compiler error, saving you some time. You can also see the type signatures of variables and functions, reducing the chances of making incorrect assumptions. 

{% highlight python %}
map(function, iterables)
{% endhighlight %}

The snippet above shows the type signature for the function `map` in Python. We can see that it wants a function and an iterable for input, according to the hopefully well-named parameters. Without knowing the meaning of map you can't tell what arguments you should pass to it. You could somewhat assume what counts as iterable, but it doesn't classify exactly what defines an iterable.  Looking at the function parameter we can't tell anything about what type the argument should have.


{% highlight c# %}
IEnumerable<R> Select<T,R>(IEnumerable<T>, Func<T,R>)
{% endhighlight %}

Here we have the type signature for the same function in C#.  `T` and `R` represents two generic types. We do not care about the actual types of the arguments, as long as all `T`'s have the same type; and same goes for the `R`'s. 

For the first argument you can pass it any C# class that implements the interface `IEnumerable<T>` of any type `T`. As opposed to Python, it clearly states what defines an iterable.

`Func<T,R>` represents a function that takes a value of type `T` and returns a value of type `R`. This means that if we pass in a list of integers, we must also pass in a function that takes an integer as input, and we will receive an `IEnumerable` of type `R` as output. The compiler will complain if we pass it anything that doesn't match.

Static typing tends to make languages more verbose when explicitly stating the types, but not necessarily. Some languages have a strong type inference. 

{% highlight haskell %}
map f [] = []
map f (x:xs) = (f x) : map f xs
{% endhighlight %}

The snippet above shows a simple implementation of `map` in Haskell.  By analyzing how I've used lists, list operators, and functions, it can infer the type signature `(a -> b) -> [a] -> [b]`.  This matches the type signature of C#'s `Select`, `a` is the `T` and `b` is the `R`, although the parameters have swapped places.  C# has it the other way because there you typically use it by doing `someObject.Select(function)` on an object, instead of passing in the object as a parameter. Haskell on the other hand, makes use of partial application where it makes more sense to apply the function first.


## Dynamic typing

Dynamically typed languages, while more overhead, usually have no compilation stage, and can thus run immediately. Compiling a large project can take several seconds, if not minutes. When you first learn a compiled language, the compilation step may not feel like any hindrance; as a small program can take less than a second to compile. 

No compilation opens up for a new cool possibility for testing your code.  A compiled language can only run your test cases as often as you compile; but in a dynamically typed language you can set up your tests to run whenever you save a file.  This way you can constantly keep track of if you break something.  If, however, you are a save-maniac like me, who hits Ctrl+S every few seconds, you may want to learn to control yourself.

Dynamic typing tends to lead to less verbose languages. Without static type checking, the need to write out types disappears. This lowers the bar for newcomers.  A less verbose language with no strict compiler yelling at them usually appears more welcoming. If you compare the previously mentioned code snippets of `map` in Python to the `Select` in C#, you can easily guess which one a new programmer would go for. 


## My experiences and opinions
I was first introduced to programming through my university when I began studying computer science. The first course taught the statically typed language C, and later on C#. The whole first year consisted of only statically typed languages before finally reaching the dynamically typed JavaScript in a course in web development. Using JavaScript felt odd, there were a lot of features I missed. Mainly the code completion and variable/function suggestions. I ran into a great deal of bugs and unexpected behavior; I guess some of these can be attributed to JavaScript specifically.

I have tried Python as well, and I had similar experiences to JavaScript with it. So as of now I am on the static side. I am, however, in no way saying that either is better or worse than the other. This just happens to be my opinion on it. Someone who was taught Python as their first language may be more inclined to prefer dynamic type systems.
