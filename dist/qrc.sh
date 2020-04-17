#!/bin/sh
set -e

#--------------------------------------------------------------------------------------------------
# Settings
#--------------------------------------------------------------------------------------------------

Sky="../../Sky"

SkyBase="$Sky/src/SkyBase"

#--------------------------------------------------------------------------------------------------

content="../content"

#--------------------------------------------------------------------------------------------------
# Syntax
#--------------------------------------------------------------------------------------------------

if [ $# != 2 -a $# != 3 ] \
   || \
   [ $1 != "qt4" -a $1 != "qt5" -a $1 != "clean" ] \
   || \
   [ $2 != "win32" -a $2 != "win64" -a $2 != "macOS" -a $2 != "linux" -a $2 != "android" ] \
   || \
   [ $# = 3 -a "$3" != "deploy" ]; then

    echo "Usage: qrc <qt4 | qt5 | clean>"
    echo "           <win32 | win64 | macOS | linux | android>"
    echo "           [deploy]"

    exit 1
fi

#--------------------------------------------------------------------------------------------------
# Configuration
#--------------------------------------------------------------------------------------------------

if [ $2 = "win32" -o $2 = "win64" ]; then

    os="windows"
else
    os="default"
fi

#--------------------------------------------------------------------------------------------------
# Clean
#--------------------------------------------------------------------------------------------------

if [ $1 = "clean" -o "$3" = "deploy" ]; then

    echo "CLEANING"

    rm -f qrc/*.qml

    rm -rf qrc/pictures

    rm -f ../bin/*.qml

    rm -rf ../bin/pictures

    if [ $1 = "clean" ]; then

        exit 0
    fi

    echo ""
fi

#--------------------------------------------------------------------------------------------------
# QML
#--------------------------------------------------------------------------------------------------

echo "COPYING QML"

cp "$content"/*.qml qrc

#--------------------------------------------------------------------------------------------------
# Content
#--------------------------------------------------------------------------------------------------

if [ "$3" = "deploy" ]; then

    echo "COPYING pictures"

    cp -r "$content"/pictures qrc
fi

#--------------------------------------------------------------------------------------------------
# Icon
#--------------------------------------------------------------------------------------------------

if [ $2 = "macOS" ]; then

    echo "GENERATING icon"

    mkdir icon.iconset

    cp pictures/icon/16.png  icon.iconset/icon_16x16.png
    cp pictures/icon/24.png  icon.iconset/icon_24x24.png
    cp pictures/icon/32.png  icon.iconset/icon_32x32.png
    cp pictures/icon/48.png  icon.iconset/icon_48x48.png
    cp pictures/icon/64.png  icon.iconset/icon_64x64.png
    cp pictures/icon/128.png icon.iconset/icon_128x128.png
    cp pictures/icon/256.png icon.iconset/icon_256x256.png
    cp pictures/icon/512.png icon.iconset/icon_512x512.png

    iconutil -c icns icon.iconset

    rm -rf icon.iconset
fi

echo ""

#--------------------------------------------------------------------------------------------------
# Deployer
#--------------------------------------------------------------------------------------------------

if [ $1 = "qt5" ]; then

    if [ $os = "windows" ]; then

        version=2.11
    else
        version=2.7
    fi
else
    version=1.1
fi

if [ $os = "windows" ]; then

    defines="WINDOWS"

elif [ $2 = "macOS" ]; then

    defines="MAC"

elif [ $1 = "linux" ]; then

    defines="LINUX"
else
    defines="ANDROID"
fi

"$Sky"/deploy/deployer qrc $version HelloSky.qrc "$defines" \
"$SkyBase"/Style.qml \
"$SkyBase"/Window.qml \
"$SkyBase"/RectangleBorders.qml \

cp -r qrc/* ../bin
