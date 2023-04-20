---
layout: post
title: "Bouncing balls simulation using X11"
date: 2021-08-02
tags: ["programming", "linux"]
categories: programming
description: "A small project where I explore the X11 API in C."
published: true
---

Recently I got the idea that I wanted to experiment with using X11 directly, instead of some higher-level library where buttons and fields already exist as objects. The goal was to get a better idea of how the graphics and window systems works in Linux (X11 specifically). This wasn't a huge project and I only got to see parts of it before moving on, but it was a very interesting experience. Especially for someone like me who has barely done any kind of graphics programming before. In doing this project I started with a template from [this guide](http://mech.math.msu.su/~vvb/2course/Borisenko/CppProjects/GWindow/xintro.html) that contained setting up a window and listening to user events inside the window. The [official documentation](https://www.x.org/releases/X11R7.6/doc/libX11/specs/libX11/libX11.html) was also very useful, along with the manpages in Linux. This post contains some short explanations of problems I encountered and discoveries I made during this project. Github: [https://github.com/cappe987/graphics-simulation](https://github.com/cappe987/graphics-simulation).

![Gif of blue circles bouncing on green circles](img/x11-project.gif)

The gif above shows my project. It is small blue balls bouncing on green balls. The blue balls fall from top to bottom and green balls can be placed or removed by left and right clicking. I know the bounce physics isn't correct but ignore that for now. The goal was just to learn about X11, not to make great physics.


## How X11 handles windows and input
X11 has 4 important variables. 
```c
Display* display;
int screen;
Window window;
GC gc;
```
`display` is a pointer to the X Server and is passed to almost every function in X11. `screen` refers to which monitor to use. `window` is the actual window that you are working with. `gc` stands for Graphics Context and holds information on how things should be drawn. Information such as colors, fonts, etc.  Any changes made to the window requires both the `display` and the `window` to be passed to the function. If it should draw something on the window itself then the `gc` also needs to be passed.

X11 handles input through events. It waits for events to happen and then it runs. When nothing is happening it is not actively running any code. By default it doesn't listen to any events. You need to set a mask for which events you want to listen to. This is done through a bitmask with the bitwise or-operator `|` in C. 

Here's an example of setting the events
```c
XSelectInput(display, window, ExposureMask | ButtonPressMask)
```
This code sets the `window` to only generate events for exposure (when contents in the window can no longer be seen due to resizing) and button press (mouse buttons). Button events is probably the simplest to understand, it generates an event when you click a button on the mouse, and the event struct received will contain information about which button. Exposure event is useful if you expect the user to resize the window. Because when it is resized it may need to be redrawn if some things in the window are no longer visible. 

## FPS-independent speed
At the start of the project the speed of the balls were dependent on the FPS of the application. This is often not desirable in games or animations because that means that the higher FPS the faster the game will move and you cannot manually control the speed. FPS in games is often not stable. It doesn't sit on just 60 FPS unless you lock it to max 60 and assuming your computer can handle it, but there's still the possibility that it occasionally drops slightly. So even small fluctuations could change the game speed if you don't lock it. The way I solved it, which probably isn't a perfect solution, was to lock it to a set amount of moves per second. Depending on how much time had passed since the last move it multiplies the velocity vector by the time difference. A time difference of 1 would indicate that exactly the right amount of time had passed. Shorter time would make it move shorter distance and longer time makes it do longer jumps, which evens it out. Although one problem with this would be if you have a really slow computer the time difference will become really high and the blue balls will make large jumps, possibly going over the green balls.

## Circles and Arcs
The X11 library provides types for drawing rectangles and arcs (circles). One issue I had with the pre-existing `XArc` was that it uses integers for position. Which makes sense given that the screen is made up of pixels and that is how X11 interacts with the screen, it colors pixels on it. But I couldn't use this `XArc` for my animation because of several reasons. One being that I simply needed more fields, like ones for velocity. But I also wanted `float` for the position. This was so the multiplication with the time difference previously explained would work correctly. Too low velocity and too fast computer could possibly result in the integers always being rounded down and therefore getting stuck in one place. I never experienced this issue myself, but I wanted to counteract this anyways. 

Another annoying issue with the circles is that when you tell X11 to draw a circle (using `XDrawArc`) the coordinates you give are in the upper left corner, as if it was a rectangle. It is not at the center of the circle. At the start I made a function called `get_center` that returned the `x` and `y` of the center of the circle. When I later made my own `Circle` struct I decided to make the coordinates be the center of the circle because those coordinates are used much more when moving and calculating the physics and collisions. Then I simply provided a function for drawing the circles that subtracted the radius from the `x` and `y` positions, since this was the only place I would ever need those coordinates. Everywhere else I needed the center of the circle.

## Redrawing and double buffers 
X11 doesn't have any concept of objects in the window. All it does is draw the pixels you tell it to draw. To move a ball I had to paint over the previous position with white (the background color) and then redraw it in the new position. This meant that I had to erase and redraw everything that was somehow affected by the change in position. The blue balls would sometimes enter the green balls slightly, and since I wasn't redrawing the green balls (as they didn't move) it ended up making tunnels and craters in the green balls when the balls erased their previous position with white. Due to this issue I decided to always draw the green balls for every frame as well.

This was working alright for a while, but then I decided to increase the amount of blue balls. This resulted in a lot of flickering on the screen. To solve this I used the Xdbe functions for double buffers. This provides a drawable buffer that you can write to and when you are done writing you call the function `XdbeSwapBuffers` to place the buffer contents on screen. The buffer also always starts blank so everything has to be redrawn every frame, so I had no choice but to draw the green balls as well. Though the double buffers worked wonderfully. I was able to run it with 10 000 blue balls at once without any graphical glitches, although the window was so cluttered it was hard to see what was happening.


## Multithreading 
The function `XNextEvent` locks the thread until it receives an event (an event specified by the previously mentioned `XSelectInput`). To be able to have continuous updating of the animation while also taking user input I needed to use a second thread. One thread to handle just the input, and another to handle all the animations. This also raises the major issue of multithreading, accessing the same data from different threads. I use the input to place down green balls, but the animation thread also needs the green balls to draw them. The usual solution to this is called *mutex*. A mutex is a variable that can be locked and unlocked. If it is locked then someone else (another thread) that tries to lock it will have to wait until the first thread unlocks it. Although mutex is no magical solution, you still need to be careful to make sure you lock it in all places where it accesses shared data. Semaphores also exist if you want to allow several, although limited, amount of threads to access something. But in this project I didn't use the mutex library because X11 has its own functions for manipulating the window from different threads. To use these you must first initalize it with `XInitThreads()`, otherwise it won't even let you access it from other threads. Then you use `XLockDisplay(display)`, which is pretty much the `pthread_mutex_lock(mutex)` function. I don't know what makes it special, but it was easy to use this to lock some shared variables as well since most of the time when I needed to lock something I was also gonna draw.


