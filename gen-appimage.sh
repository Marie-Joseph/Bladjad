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

if [ ! -d $PREFIX ]; then
    linuxdeploy --appdir $APPIMAGE_PREFIX;
fi;

if [ ! -d $DATA_DIR ]; then
    mkdir -p $DATA_DIR;
fi;

if [ ! -d $DESKTOP_DIR ]; then
    mkdir -p $DESKTOP_DIR;
fi;

echo "--------------------";
echo "Copying resources...";
cp -r images $IMAGES_DIR;
cp -r fonts $FONTS_DIR;

echo "--------------------";
echo "Copying desktop files..."l
cp $PROG_NAME.desktop $DESKTOP_DIR/
for size in 16 32 64 128 256; do
    cp icons/${size}x${size}/bladjad-icon.png $ICONS_DIR/${size}x${size}/apps/;
done;

echo "--------------------";
echo "Installing binary...";
mv $PROG_NAME $BIN_DIR/$PROG_NAME;

echo "--------------------";
echo "Second linuxdeploy...";
linuxdeploy --appdir $APPIMAGE_PREFIX --output appimage;

echo "--------------------";
echo "Done~!";
