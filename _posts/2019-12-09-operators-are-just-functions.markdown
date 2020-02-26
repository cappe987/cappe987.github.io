---
layout: post
title: "Operators are functions too"
date: 2019-12-09
categories: ""
published: true
---

# Introduction

Most programming languages today have a bunch of operators for different 
purposes. Usually for mathematical, logical, comparison, and bitwise 
operations. `+`, `-`, `*`, `/`, `&&`, `||`, exists in probably every modern 
language. Developers expect them to exist; no one would want to program without them.

Many languages like to extend their operators, usually `+`, to work on several 
types. Python allows using the plus operator on both strings and 
numbers. The interpreter accepts both `"AB" + "CD"` and `3 + 5`; 
but these are not the same operation, just the same operator. 
Addition on numbers is commutative, `3 + 5 == 5 + 3`; addition on 
strings is not, `"A" + "B" != "B" + "A"`.


**Operator:** 
> a symbol or function denoting an operation (e.g. ×, +).

**Operation:** 
> an action to be performed on some data.

Languages do this through operator overloading, either built in to the 
compiler/interpreter, or as a part of the actual language. You specify 
what operation an operator should do for a specific class/type. While integer addition 
adds up the numbers, string addition
(also known as concatenation) appends the second string to the end of the first to 
create a new string. If you do add any yourself, you shouldn't give them 
completely different behavior than what the symbol usually means. 
Using the `+` operator on Vectors shouldn't perform a cross product just 
because you thought it seemed convenient. 


# Operators as functions
You may think of operators as these magical symbols that the developers 
programmed into the language. While partially true, you can also see an 
operator as a infix function (excluding Lisp, where verything is prefix). 
Think of `>` as a function. What parameters does it have and what does 
it return?

<details class="details">
<summary class="summary">Click to expand: greater-than type signature</summary>
{% highlight fsharp %}
(int -> int -> bool)
{% endhighlight %}
In a more familiar style: 
{% highlight csharp %}
bool greaterThan(int a, int b);
{% endhighlight %}
This is not accounting for any other possible operator overloading, 
such as strings or other number types (eg. float/double).
</details>
<br/>

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

You can usually express operators in terms of other operators. In C you 
can define `+` and `-` using bitwise operators; and in turn you can 
define `*` and `/` with those. Assuming you have other language constructs 
such as loops and if-statements available. Integer equality and comparison 
can be expressed with the help of subtraction. Logical operators can be 
expressed with equality. 

At the time of writing this I am currently working on making an interpreter 
for my own Lisp-like language. I was having some trouble figuring out how to 
handle the operators. Do I treat them as functions? Or is it better to 
see them as operators and parse them as such? To minimize the amount of 
operators I realized I could define the logical operators with the help 
of only the equality operator; and could thus put them in the standard 
library for the language. A few less operators to worry about. 
Unfortunately I couldn't take it any further than that; as the language 
I'm making is rather high-level. The rest of the standard operators 
are hardcoded in the parser, but are parsed as function calls to 
allow for easier partial application and less types to worry about.

{% highlight csharp %}
bool and(bool a, bool b){
  if(a == true){
    if(b == true){
      return true;
    }
  }
  return false;
}
{% endhighlight %}

# Defining your own operators

Once again, only some languages allow defining custom operators. 
When talking about operators I am speficially talking about 
binary operators in this context. 
An example of a unary operator (one argument) is `-` when placed 
right in front of a numerical to create a negative number `a = -2`.
A ternary operator (three arugments) commonly exists in the form of a 
one line if-else statement `condition ? when true : when false`.
Less common operators like unary and ternary have their uses, but
not in this post.

Defining your own operators has no logical benefit in the sense that it 
changes the way your program works. You could consider it syntactic sugar, 
but it can improve readability a lot. If you find yourself in a project where 
you are using a certain functionality a lot, you can consider if you 
want to make a custom operator. The symbols I chose for the example below has
no meaning in any context that I am aware of, other than that they are legal 
symbols for custom operators in Haskell.

{% highlight haskell %}
add5div a b = (a + 5) / (b + 5)
( <@> ) a b = add5div a b
10 <@> 5 -- returns 1.5
{% endhighlight %}

Haskell has a bunch of code-defined operators in the standard libary 
to help with certain actions in its very intricate type system. For 
example: `$`, `<$>`, `<*>`, and `>>=`.

Defining custom operators is more common in functional programming languages than 
imperative ones. Imperative has all these state-manipulating statements 
and function calls, while in functional languages everything is done 
by composing functions, which makes operators very useful. Instead of 
passing two different data into a function as arguments, you use that function 
as an operator to make it look more elegant. Function calls become less 
cluttered and, if you are familiar with the operator, easier to read.