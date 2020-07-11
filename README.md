# Bladjad
Blackjack without the 'c's, 'kays?

## Overview
Bladjad is simply blackjack. It's written in D using [Dgame](http://dgame-dev.de).
It uses free assets found on itch.io and collected [here](https://itch.io/c/1043053/blackjack-assets).

## Compilation
Since Bladjad is written in D, compilation should be extremely simple. Install a
D compiler for your system, as well as the dub build manager if it's not included.
You'll also need SDL and OpenGL development files.
Then, simply clone this repository and navigate to its root directory. There,
run `dub build bladjad`. A binary will be produced in the same directory.

Once at 1.0, Bladjad will be distributed on itch.io. Until then, the binary must
be in the same directory as the fonts and images directories.

## Controls
Bladjad's control scheme is simple and, hopefully, intuitive - feedback welcome.
In the menu screen, navigate with arrow keys and select with 'enter'.
In-game, 'h' hits, 's' stands, and 'm' returns to the menu. For testing purposes,
'r' will reset the game; whether this is final is TBD.

## Contributions
At this time, no code contributions will be accepted here. Feedback is very
welcome, especially feedback on appearance including UI. Bug reports are begged,
especially score miscalculations. If you think the score has been miscalculated,
please take a screenshot of the final hands.
