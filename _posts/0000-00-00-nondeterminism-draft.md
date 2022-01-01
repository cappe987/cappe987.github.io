---
layout: post
title: "Nondeterministic functions"
date: 2021-08-06
tags: programming computer_science math
published: false
---

In a [previous post]({% post_url 2021-07-25-functions-deep-dive %}) I talked about deterministic functions and some useful properties they have. I recommend you read that one first if you haven't already. But deterministic functions aren't all that useful to get tasks done. They only transform data from one form to another, but cannot actually read input from the console or even print to the console. A program consisting of only deterministic functions will always perform the same calculation, and given that it doesn't have input or output it will only use whatever numbers it was compiled with. It essentially becomes a black box that does some computation without ever showing the result. It is just a waste of time. To do anything useful we need input and output (IO) in one way or another. This doesn't mean every function should be nondeterministic. I still encourage you to make as much as possible deterministic, for the reasons outlined in the previous post. But IO is a must.

<!--Nondeterministic vs deterministic. Black boxes aren't very useful.-->

## Types of nondeterminism
Nondeterminism comes in many forms. Some which may not be directly obvious. I want to cover them in a bit more detail and explain specifically what they are.


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

**IO** is also the obvious one which I've already mentioned. Reading from or printing to console, reading/writing files, http requests, database requests. Anything that interacts with the world outside of the program itself. This is because everything outside the program is subject to possible changes at any time (from the program's perspective). The data in the database may change. The file it reads may have changed.

**Exceptions** interrupt the flow of the whole program. 

<!--### Random values-->


## Interesting takes on handling nondeterminism
Random Values: Stochastic processes and probabilities
Exceptions: Java forced exceptions. Similar to Haskell Maybe/Either type
IO: Haskell IO. Debug module for nondeterminism

