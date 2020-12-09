#!/bin/sh

COMPILER=dmd

PROG_NAME=bladjad
PLATFORM=FreeBSD
ARCH=x86_64
PKG_NAME=$PROG_NAME-$PLATFORM-$ARCH

if [ ! -d $PKG_NAME ]; then
	echo "----------------------";
	echo "Making $PKG_NAME...";
	mkdir $PKG_NAME;
fi;

if [ ! -f $PROG_NAME ]; then
	echo "----------------------";
	echo "Building $PROG_NAME...";
	dub build -q --build=release --compiler=$COMPILER;
fi;

echo "----------------------";
echo "Moving files...";
mv $PROG_NAME $PKG_NAME/;
cp -r fonts $PKG_NAME/;
cp -r images $PKG_NAME/;
cp install.sh $PKG_NAME/;
cp README.md $PKG_NAME/;

echo "----------------------";
echo "Creating archive...";
tar cJf $PKG_NAME.txz $PKG_NAME;
