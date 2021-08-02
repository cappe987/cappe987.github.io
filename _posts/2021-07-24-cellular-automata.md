---
layout: post
title: "Cellular automata"
date: 2021-07-24
tag: computer_science
published: true
---

Cellular automata is way to model biological systems through a set of
cells that change their state based on their surroundings [[1](#cellular)]. It
requires some form of grid to operate on, where each location on the
grid contains one cell. The cells are based on integer coordinates on
the grid. The second requirement is a set of rules that determine when a
cell should change state and to what state. The third and final
requirement is an initial state, what it looks like at the start. Then
the rules can be applied on all the cells to update their states.
Applying the rules can be done as many times as you wish. Each
application is called a *step*. Over time, when applying these rules
certain behaviours may exhibit in the grid. This shows the interaction
of the cells as a system.

One of the most famous cellular automata is Conway's Game of Life and it
models over- and underpopulation [[1](#cellular)]. It takes place on a
2-dimensional plane of integers. Each cell can either be alive or dead.
The rules are as follows:

1.  If a cell has 0 or 1 living neighbour (out of its 8 neighbours) then
    it dies.

2.  If it is alive and has 2 or 3 living neighbours then it stays alive.

3.  If it is dead and has 3 living neighbours then it becomes alive.

4.  If it has 4 or more living neighbours then it dies.

![A glider in Conway's Game of Life](/assets/cellular-automata-glider.png)

Too few neighbours and it dies of underpopulation, too many and it dies
of overpopulation. Just the right amount and new cells are born. The image above 
shows a *glider* in Conway's Game of Life. It is a set of cells that
will continuously move diagonally (towards the bottom right in this
image) until they collide with something else that disrupts the
formation. Gliders are a stable formation because over a couple of steps
it will return to its initial formation, thus making it go on forever in
the same pattern.

Some useful applications of cellular automata [[2](#uses)] include simulation
of:

-   Gas spread

-   Forest fire spread

-   Bacterial growth

-   Flow of electricity

These are areas that can be hard and complex to model accurately using
conventional computation methods, but by constructing simple rules a
cellular automaton can represent them very well, and be computed in a
very efficient manner.

Heinonen and Pukkala [[3](#trees)] have applied cellular automata to forest planning using
two-state cells on a hexagonal grid. With two states, one represented a
stand (area of trees planted at the same time) that should be thinned
out by cutting down some trees and the other represented a stand that
should be kept as is. They later added a third state that indicated
regeneration cutting, which means cutting down a lot or most of the
trees to prepare for new trees. Using the cellular automata they have to
compute way less than previous methods and also managed to get better
results.

Cellular automata can also be self-organizing [[4](#stephen)]. This means
that over time they will tend towards a certain pattern, much like
certain constructs that can be found in nature. Like cellular automata,
biological systems also use small components to gradually build
structures.

# References
<a name="cellular"/>
[1] Eric W Weisstein. *Cellular Automaton*. URL: <https://mathworld.wolfram.com/CellularAutomaton.html>.

<a name="uses"/>
[2] Michael J Young. *Typical Uses of Cellular Automata*. Nov. 2006. URL: <http://www.mjyonline.com/CellularAutomataUses.htm>.

<a name="trees"/>
[3] Tero Heinonen and Timo Pukkala. "The use of cellular automaton approach in forest planning". In: *Canadian Journal of Forest Research 37* (Nov. 2007), pp. 2188-2200. DOI: 10.1139/X07-073.

<a name="stephen"/>
[4] Stephen Wolfram. "Cellular Automata". In: (1983).
