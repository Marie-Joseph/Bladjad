#!/bin/sh

export VERSION="0.1";

# Note that dmd produces the smallest AppImages,
# but ldc2 produces the smallest binaries.
# gdc is comparable to ldc2 AppImages
# but to dmd binaries.
# DMD64 - 2.094.0
# LDC2 - 1.21.0
# GDC - Ubuntu 10.2.0-13ubuntu1
COMPILER=dmd

PROG_NAME=bladjad
STD_PREFIX=usr
APPIMAGE_PREFIX=AppDir
PREFIX=$APPIMAGE_PREFIX/$STD_PREFIX
BIN_DIR=$PREFIX/bin
LIB_DIR=$PREFIX/lib
DATA_DIR=$PREFIX/share/$PROG_NAME
DESKTOP_DIR=$PREFIX/share/applications
FONTS_DIR=$DATA_DIR/fonts
IMAGES_DIR=$DATA_DIR/images
ICONS_DIR=$PREFIX/share/icons/hicolor

if [ ! -e $PROG_NAME ]; then
    echo "--------------------";
    echo "Building $PROG_NAME...";
    dub build -q --build=release --compiler=$COMPILER;
fi;

echo "--------------------";
echo "First linuxdeploy...";
if [ ! -d $PREFIX ]; then
    linuxdeploy --appdir $APPIMAGE_PREFIX;
fi;

echo "--------------------";
echo "Creating $DATA_DIR...";
if [ ! -d $DATA_DIR ]; then
    mkdir -p $DATA_DIR;
fi;

echo "--------------------";
echo "Copying resources...";
cp -r images $IMAGES_DIR;
cp -r fonts $FONTS_DIR;

echo "--------------------";
echo "Second linuxdeploy...";
linuxdeploy --appdir $APPIMAGE_PREFIX --output appimage -e $PROG_NAME -d $PROG_NAME.desktop -i icons/16/$PROG_NAME-icon.png -i icons/32/$PROG_NAME-icon.png -i icons/64/$PROG_NAME-icon.png -i icons/128/$PROG_NAME-icon.png -i icons/256/$PROG_NAME-icon.png;

echo "--------------------";
echo "Done~!";
