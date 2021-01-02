# Bladjad
Blackjack without the 'c's, 'kays?

## Overview
Bladjad is simply blackjack. It's written in D using [Dgame](http://dgame-dev.de).
It uses free assets found on itch.io and collected [here](https://itch.io/c/1043053/blackjack-assets).

## Controls
Bladjad can be used entirely with a mouse. However, it also uses a
keyboard control scheme which is simple and, hopefully, intuitive.
#### Menu
* _Arrow keys_ - navigate
* _Enter key_ - select highlighted option
#### In-Game
* _H key_ - hit
* _S key_ - stand
* _R key_ - restart
#### Universal
* _M key_ - return to the menu
* _Q key/Escape key_ - exit

## Installation
As of version 0.1, some preliminary executable files will be made available.
The goal is to support an AppImage for Linux, a tarball for FreeBSD, a Windows
executable, and an OSX executable.

### Compiling from source
Since Bladjad is written in D, compilation should be relatively simple. Install a
[D compiler](https://dlang.org/download.html) for your system, as well as the [DUB build manager](https://code.dlang.org/packages/dub) if it's not included.
You'll also need SDL and OpenGL development files [for Dgame](http://dgame-dev.de/index.php?controller=learn&mode=tutorial&version=0.6&tutorial=install).
Then, simply clone this repository and navigate to its root directory. There,
run `dub build --build=release --compiler=yourDCompiler`. A binary will be produced
in the same directory. Alternatively, you can clone a build branch, such as `appimage`,
which will include specific compilation instructions for that format. Once you have the
executable, you can install it manually or as the format requires. The full set of
commands, with standin names:
```
git clone https://github.com/Marie-Joseph/bladjad.git branch-of-choice
cd Bladjad
dub build --build=release --compiler=yourDCompiler
```
