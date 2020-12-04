## Compiling to an AppImage

### Requirements
You should check the compilation instructions in README.md
to make sure you have everything you need. Additionally,
you'll need to get ahold of [linuxdeploy](https://github.com/linuxdeploy/linuxdeploy),
make it executable, and put it in your `$PATH`.

### Commands
All you need to do is execute the script `gen-appimage.sh`.
You should check to make sure all relevant configuration
matches what you want; for example, the default compiler is
dmd. Then simply run `. gen-appimage.sh`.
