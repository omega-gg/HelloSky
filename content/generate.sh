#!/bin/sh
set -e

#--------------------------------------------------------------------------------------------------
# Settings
#--------------------------------------------------------------------------------------------------

Sky="../../Sky"

SkyBase="$Sky/src/SkyBase"

#--------------------------------------------------------------------------------------------------

content="../content"

bin="../bin"

#--------------------------------------------------------------------------------------------------
# Syntax
#--------------------------------------------------------------------------------------------------

if [ $# != 2 -a $# != 3 ] \
   || \
   [ $1 != "qt4" -a $1 != "qt5" -a $1 != "clean" ] \
   || \
   [ $2 != "win32" -a $2 != "win64" -a $2 != "win32-msvc" -a $2 != "win64-msvc" -a \
     $2 != "macOS" -a $2 != "linux" -a $2 != "android" ] \
   || \
   [ $# = 3 -a "$3" != "all" -a "$3" != "deploy" ]; then

    echo "Usage: generate <qt4 | qt5 | clean>"
    echo "                <win32 | win64 | win32-msvc | win64-msvc | macOS | linux | android>"
    echo "                [all | deploy]"

    exit 1
fi

#--------------------------------------------------------------------------------------------------
# Configuration
#--------------------------------------------------------------------------------------------------

if [ $2 = "win32" -o $2 = "win64" -o $2 = "win32-msvc" -o $2 = "win64-msvc" ]; then

    os="windows"
else
    os="default"
fi

if [ "$3" = "deploy" -o $2 = "android" ]; then

    path="qrc"
else
    path="$bin"
fi

cd ../dist

#--------------------------------------------------------------------------------------------------
# Clean
#--------------------------------------------------------------------------------------------------

if [ $1 = "clean" ]; then

    echo "CLEANING"

    rm -f  $bin/*.qml
    rm -rf $bin/pictures
    rm -rf $bin/videos

    rm -rf qrc
    touch  qrc/.gitignore

    exit 0
fi

#--------------------------------------------------------------------------------------------------
# QML
#--------------------------------------------------------------------------------------------------

echo "COPYING QML"

cp $content/*.qml $path

#--------------------------------------------------------------------------------------------------
# Content
#--------------------------------------------------------------------------------------------------

if [ "$3" = "all" -o "$3" = "deploy" -o $2 = "android" ]; then

    echo "COPYING pictures"

    cp -r $content/pictures $path

    if [ "$3" = "all" ]; then

        echo "COPYING videos"

        if [ $2 = "android" ]; then

            cp -r $content/videos/* ../dist/android/assets/videos
        else
            cp -r $content/videos $path

            rm $path/videos/.gitignore
        fi
    fi
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

    defines="DESKTOP WINDOWS"

elif [ $2 = "macOS" ]; then

    defines="DESKTOP MAC"

elif [ $1 = "linux" ]; then

    defines="DESKTOP LINUX"
else
    defines="ANDROID"
fi

"$Sky"/deploy/deployer $path $version HelloSky.qrc "$defines" \
"$SkyBase"/Style.qml \
"$SkyBase"/Window.qml \
"$SkyBase"/RectangleBorders.qml \
"$SkyBase"/BaseButton.qml \
