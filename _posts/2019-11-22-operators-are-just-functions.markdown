---
layout: post
title: "Operators are just functions"
date: 2019-11-22
categories: ""
published: false
---

# Introduction

Most programming languages today have a bunch of operators for different 
purposes. Usually for mathematical, logical, comparison, and bitwise 
operations. `+`, `-`, `*`, `/`, `&&`, `||`, exists in probably every language. Developers 
expect them to exist; no one would want to program without them.

Many languages like to extend their operators, usually `+`, to work on several 
types. Python allows using the plus operator on both strings and 
numbers. The interpreter accepts both`"AB" + "CD"` and `3 + 5`; 
but these are not the same operation, just the same operator. 
Addition on numbers is commutative, `3 + 5 = 5 + 3`; addition on 
strings is not, `"A" + "B" != "B" + "A"`.

Languages do this through operator overloading. You specify what an operator should do 
for a specific class. While integer addition adds up the numbers, string addition
(also known as concatenation) appends the second string to the end of the first to 
create a new string. If you do add any yourself, you shouldn't give them 
completely different behavior than what the symbol usually means. 
Using the `+` operator on Vectors shouldn't perform a subtraction just 
because you thought it seemed convenient.


# The real face of operators
You may think of operators as these magical symbols that the developers 
programmed into the language. While partially true, you can also see an 
operator as a infix function (excluding Lisp, where verything is prefix). 
Think of `>` as a function. What parameters does it have and what does 
it return?

<details class="details">
<summary class="summary">Answer: greater-than type signature</summary>
{% highlight fsharp %}
(int -> int -> bool)
{% endhighlight %}
In a more familiar style: 
{% highlight csharp %}
bool addition(int a, int b);
{% endhighlight %}
This is not accounting for any other possible operator overloading, 
such as strings or other number types (eg. float/double).
</details>


Some programming languages lets you treat operators like a function. In the code 
snippet below, we assign the plus operation to the function `addition`

{% highlight haskell %}
addition = (+) -- (int -> int -> int)
addition 3 5 -- returns 8
{% endhighlight %}

Haskell also lets you treat regular functions as infix function.

{% highlight haskell %}
3 `addition` 5 -- returns 8
{% endhighlight %}


# Defining your own operators

Once again, only some languages allow defining custom operators. 
When talking about operators we are speficially talking about 
binary operators in this context. 
An example of a unary operator is `-` when placed 
right in front of a numerical to create a negative number `a = -2`.
A ternary operator commonly exists in the form if a one-line return if-else 
statement `condition ? when true : when false`.
Less common operators like unary and ternary have their uses, but
not in this post.

Defining your own operators has no logical benefit in the sense that it 
changes the way your program works. You could consider it syntactic sugar, 
but it can improve readability a lot. If you find yourself in a project where 
you are using a certain functionality a lot, you can consider if you 
want to make a custom operator. 

{% highlight haskell %}
add5div a b = (a + 5) / (b + 5)
( <@> ) a b = add5div a b
10 <@> 5 -- returns 1.5
{% endhighlight %}


Haskell has a handful of code-defined operators in the standard libary 
to help with certain actions in its very intricate type system. 


{% highlight haskell %}
$
<$>
<*>
>>=
{% endhighlight %}

