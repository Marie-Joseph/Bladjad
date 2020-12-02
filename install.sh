#!/bin/sh

PROG_NAME=bladjad
INSTALL_DIR=AppDir
FONTS_DIR=fonts
IMAGES_DIR=images

if [ ! -e $PROG_NAME ]; then
    dub build;
fi;

if [ ! -d $INSTALL_DIR ]; then
    mkdir $INSTALL_DIR;
fi;

cp -r $IMAGES_DIR $INSTALL_DIR/$IMAGES_DIR;
cp -r $FONTS_DIR $INSTALL_DIR/$FONTS_DIR;
mv $PROG_NAME $INSTALL_DIR/$PROG_NAME;
