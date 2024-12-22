---
layout: post
title: "Nondeterministic functions"
date: 2022-01-01
tags: ["programming"]
categories: programming
description: "Types of nondeterminism and interesting ways of handling them."
---

In a [previous post]({{< ref "2021-07-25-functions-deep-dive.md" >}}) I talked about deterministic functions and some useful properties they have. I recommend you read that one first if you haven't already. But deterministic functions aren't all that useful to get tasks done. They only transform data from one form to another, but cannot actually read input from the console or even print to the console. A program consisting of only deterministic functions will always perform the same calculation, and given that it doesn't have input or output it will only use whatever numbers it was compiled with. It essentially becomes a black box that does some computation without ever showing the result. It is just a waste of time. To do anything useful we need input and output (IO) in one way or another. This doesn't mean every function should be nondeterministic. I still encourage you to make as much as possible deterministic, for the reasons outlined in the previous post. But IO is a must for any useful program.

<!--Nondeterministic vs deterministic. Black boxes aren't very useful.-->

## Types of nondeterminism
Nondeterminism comes in many forms. There were 3 main ones that I could think of, that I will talk about here. Though you might be able to find more, and probably different subcategories of each of them as well.

**Global state** means to change the values of variables that live in the global scope, or any scope that is outside the function. Static class variables are also included here. The way it creates nondeterminism is pretty obvious. Changing state will make the function behave differently the next time. Modifying a reference is another way to change the state. References are a pointer to a variable. If you pass a reference to a variable you can then modify the original. The function below demonstrates nondeterminism through a global variable.
```py
x = 10
def f(y):
  global x
  x += 1
  return y + x

print(f(5)) # prints 16
print(f(5)) # prints 17
```

**IO** is also the obvious one which I've already mentioned. Reading from or printing to console, reading/writing files, http requests, database requests. Anything that interacts with the world outside of the program itself. This is because everything outside the program is subject to possible changes at any time (from the program's perspective). The data in the database may change. The file it reads may have changed. **Random values** is a subcategory of IO since random numbers need to be seeded from the operating system, unless you want the same random sequence every time you execute. Random values will therefore also contribute to nondeterminism.

**Exceptions** interrupt the flow of the program when they occur. Exceptions as a concept is a problem for determinism since the program no longer executes as expected. Zero-division exception is a common exception that can occur in many places and even in languages that don't want to use exceptions, like Haskell. You could do controlled handling of zero division, but doing that everywhere is a massive pain. Though having an exception crash the entire program is a fair way of handling errors. Determinism becomes even harder when raising exceptions and specifically **catching** them is an integral part of the language. Now a function can either return normally, or it can return with an exception that may or may not be caught. If you do catch it then you have two types of returns you can do, one which can come from anywhere deep inside that function call. And sometimes you may not even be aware of certain exceptions that may happen in your code.

## Interesting takes on handling nondeterminism
Haskell is a language that tries to avoid nondeterminism as much as possible, and therefore has some interesting ways to handle the above mentioned problems. Global state is easily solved by simply not allowing any global state. You can write code perfectly fine without it. This was proven by Alonzo Church, the creator of Lambda calculus. Lambda calculus is functionally equivalent to the Turing machine that Alan Turing created, of which all modern computers are based on.

IO is significantly tricker, and originally Haskell was just a black box that you compiled, ran, and then you would be able to look at the return value of the main function once it was done. It had no actual IO support. As time went on they added support for IO in the main function, but everything else had to be deterministic. Finally they added support for IO everywhere, though very restricted to be able to enforce determinism. IO in Haskell is wrapped in a **monad** (I will not explain what a monad is). This meant that any function that does IO must return an IO monad. Therefore, any function that does IO must eventually return its IO operation back to the main function. Because of Haskell's type system the IO must also be included in the function types. Looking at a function signature you can immediately know if it does any IO or not. This makes you more wary of using IO. (On a side note, Haskell has debugging functions that lets you print values anywhere, but this is strictly for debugging and they live in the debugging module).

Yet again, Haskell is a prime example of how exceptions can be handled. It has the types `Maybe` and `Either`. `Maybe` simply returns `Just` a value, or `Nothing`. This would be similar to having a function return a value, or `null`. With one slight difference. In Haskell you have to handle the type by checking if it is `Just` or `Nothing` before being able to use the value inside it. It's impossible to get something like `NullPointerException` later because you forgot to check for `null`. `Either` type is an extension to `Maybe` in that instead of `Nothing` it returns something else. This is usually an error message in the form of a string. But it could be any other value, though you still know whether it was the right or wrong return value. 

Interestingly enough, Java has also built upon this concept of making the exceptions explicit and forcing you to handle it. If a function can throw some exception it has to be declared in the type signature. Anywhere that function is called you must either handle that exception or explicitly write that your new function can also throw that exception since it will propagate up the call stack. And regarding the handling of null values Kotlin uses a method similar to Haskell by forcing you to check if it's `null` or not before you can use the value.

The reason I wanted to talk about nondeterminism is because being aware of it is an important step to writing better code. As we concluded in the previous post, deterministic functions are easier to debug. I encourage you to make your functions deterministic whenever possible and keeping in mind the possible ways you might break that property.
