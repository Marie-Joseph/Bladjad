# Bladjad
Blackjack without the 'c's, 'kays?

## Overview
Bladjad is simply blackjack. It's written in D using [Dgame](http://dgame-dev.de).
It uses free assets found on itch.io and collected [here](https://itch.io/c/1043053/blackjack-assets).

## Compilation
Since Bladjad is written in D, compilation should be relatively simple. Install a
[D compiler](https://dlang.org/download.html) for your system, as well as the [DUB build manager](https://code.dlang.org/packages/dub) if it's not included.
You'll also need SDL and OpenGL development files [for Dgame](http://dgame-dev.de/index.php?controller=learn&mode=tutorial&version=0.6&tutorial=install).
Then, simply clone this repository and navigate to its root directory. There,
run `dub build bladjad`. A binary will be produced in the same directory.

Once at 1.0, Bladjad will be distributed on itch.io with installation scripts.
Until then, make sure to keep the binary in the same directory as the fonts and
images directories, wherever you choose that to be.

## Controls
Bladjad's control scheme is simple and, hopefully, intuitive.
### Menu:
_Arrow keys_ - navigate
_Enter key_ - select highlighted option
### In-Game
_H key_ - hit
_S key_ - stand
_R key_ - restart
### Universal
_M key_ - return to the menu

## Contributions
At this time, no code contributions will be accepted here. However, any bugs,
especially in score calculation, should be reported here; and feedback on
anything, especially UI, is welcome.
