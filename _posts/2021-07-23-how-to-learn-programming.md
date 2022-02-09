---
layout: post
title: "Programming: how to learn it and how to get help."
date: 2021-07-23
categories: ""
published: true
---

This article is intended to be read by someone who is looking to learn programming or is just starting out. This doesn't tell you what programming language to choose or what tutorials to follow. Only some general tips to keep in mind when learning.

## Table of Contents
* [What is programming?](#whatis)
* [How to learn programming](#learn)
* [How to watch/read tutorials](#tutorials)
* [How to Google](#google)
* [How to ask for help](#ask)


<a name="whatis"/>

## What is programming?
Many people think that programming is all about writing code. But the main job a programmer does is solve problems. Writing code is just the actual solution to the problem. You still need to figure out how to solve it first. Just like an engineer must plan and measure everything before building a bridge, the bridge itself is the final product but many hours go into just figuring out how it should be done. Or if we compare it to math. Solving a math problem requires you to first figure out what kind of problem it is. What formulas will you need? Then once you know that you can start doing the calculations, the equivalent of writing code. 

Programming problems are often generalized problems. The code should work for any values of x and y. A basic math question could be “If Bob has $5 and John has $3. Who has more money?”. This question can easily be answered by looking at the values. The bigger number is the answer. But if we generalize this to “If Bob has $x and John has $y. Who has more money?”. Now we only have x and y to work with, we can’t simply look at the number. We need to formalize a way to decide who has more money in terms of the variables x and y. Given that the answer depends on the values of x and y we need to ask the computer a question. The simplest question we can ask is “Is x bigger than y?”. If the answer is yes, then Bob has more. Else, John has more (or equal). 

<a name="learn"/>

## How to learn programming
The best way, and often the only way, to learn something properly is learning by doing. You don’t get good at math by reading problems, you get good at it by doing exercises, by using math. Same is true for programming. It is very important that you write a lot of code by yourself. Following along with a tutorial is a good way to learn, but don’t just write the same code they do. Play around with their code. Try your own variations. Think for yourself!

I don’t know any French, but I can still write down what someone else is writing without ever learning what it means or how to use the words I’ve written. That’s why it’s important to experiment by yourself. And unlike learning a spoken language, programming languages will tell you if you are doing right or wrong. If it’s a syntax error, which  means invalid grammar in the programming world, then the program will tell you so and approximately where the problem is (it's not always exact, if you can't find it then try looking at the lines before the error. Sometimes mistakes on previous lines aren't considered errors until something else comes later). If it’s a logical error, you will find that out when you run the code and it doesn’t work as expected.

Which brings me to another point. Don’t be afraid of running your code. I often see beginners asking “is this correct?” and sending a code snippet. I always respond with “does it give the expected result?”, which more often than not gives back the response “I don’t know, I haven’t tried it”. Well, why haven’t you tried it? Don’t waste my time asking if it is correct when you can get the right answer in a few seconds yourself. A much better question to ask is “How can I improve this code?” or “Can I have some feedback on my code?” after you have solved a problem. 

<a name="tutorials"/>

## How to watch/read tutorials
When watching tutorials, or reading a book, or whatever way you choose to learn, don’t rush through the topics. Going through 20 topics in one day is going to leave you more confused than when you started. You are overloading your brain with new information. Take one or two topics/videos at a time and spend some time digesting that content until you have a decent understanding of it. I sometimes see these several hours long tutorials show up on YouTube. Just because it's one video doesn't mean you should binge watch it and then expect to have learnt it all. Most of them are divided into clear sections. Split up those 4-8 hours of video over the course of 2 weeks. Watch 30 minutes daily and focus on those parts. As I mentioned earlier, play around with the concepts covered in the tutorial. If you don’t understand it, rewatch it and try again, or ask someone else for an explanation. Sometimes it helps to hear it explained in a different way.

If you are struggling to understand or to solve a problem:
1. Go back and read again to make sure you understand the concepts needed.
2. Google for how to solve the problem (see section below on [How to Google](#google)).
3. Ask for help (see section below on [How to ask for help](#ask))

<a name="google"/>

## How to Google
When Googling for help you should be as specific as possible with your search query. If you are making a snake game, don’t google “How to make a Snake game?”. Instead search about exactly the part you are stuck on. Maybe the question should be “How do I make a program with graphics/colors?” or “How do I make my Snake longer?”, or even better if you can explain it in programming terms. The more general you can make your question the more likely you are to find an answer. This does not mean to ask vague questions. It should still be specific about the problem. It is also a good idea to start your query with the name of the programming language, for example, "python snake game how to make snake longer". It can also be a good idea to leave out irrelevant words such as "the", "i", "a". Shorter search queries are often better, as long as you don't leave out any important details.

<a name="ask"/>

## How to ask for help
Don’t ask for help immediately. Always try to find an answer online first by Googling. Spend maybe 30 minutes on Google, reading relevant articles or watching videos. Maybe even sleep on it and try again tomorrow. After that you can ask for help online. As an active helper online it is not fun to help someone who has put in zero effort to understand their problem. Sometimes I see people just posting the code and saying "it doesn't work". Sometimes they can't explain in what way their code doesn't work, that shows that you haven't even understood what you are trying to do. It should be easy to say "X should happen but Y happens instead". Why should we put in the effort to help you if you aren't willing to put in the effort yourself? By searching online first you may also get some understanding, which might get clarified by someone explaining directly. Even if you don't find your answer online you will still have had some ideas put in the back of your mind.

Discord communities are a great place for beginners. When you finally ask for help, be as specific as possible. Explain the issue in detail and provide all information about the problem (if it’s an exercise you have found somewhere then please send the whole exercise description or a link to it). Sending parts of the relevant code is also very helpful. Going back to the previous example of “How do I make my snake longer?” you will probably need to explain how you have coded your snake so far and show the code for it. That way you can get help with how you should proceed. Without knowing what your code looks like you often can’t get an exact answer to such a question. Depending on what your code looks like one solution may be much more difficult than another.

I also recommend reading this: [don't ask to ask, just ask](https://dontasktoask.com/). In short, don't ask "can anyone help me with X?". Instead explain your problem directly.




