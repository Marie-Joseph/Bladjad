#!/bin/sh

export VERSION="0.1";

COMPILER=dmd

PROG_NAME=bladjad
STD_PREFIX=/usr/local
PREFIX=$STD_PREFIX
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

if [ ! -d $DATA_DIR ]; then
	echo "--------------------";
	echo "Creating $DATA_DIR...";
	mkdir -p $DATA_DIR;
fi;

if [ ! -d $DESKTOP_DIR ]; then
	echo "--------------------";
	echo "Creating $DESKTOP_DIR...";
	mkdir -p $DESKTOP_DIR;
fi;

echo "--------------------";
echo "Copying resources...";
cp -r images $IMAGES_DIR;
cp -r fonts $FONTS_DIR;

echo "--------------------";
echo "Copying desktop files...";
cp $PROG_NAME.desktop $DESKTOP_DIR/
for size in 16 32 64 128 256; do
    cp icons/${size}x${size}/bladjad-icon.png $ICONS_DIR/${size}x${size}/apps/;
done;

echo "--------------------";
echo "Installing binary...";
mv $PROG_NAME $BIN_DIR/$PROG_NAME;

echo "--------------------";
echo "Done~!";
