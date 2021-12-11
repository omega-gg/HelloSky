#!/bin/sh
set -e

#--------------------------------------------------------------------------------------------------
# Settings
#--------------------------------------------------------------------------------------------------

Sky="../../Sky"

SkyBase="$Sky/src/SkyBase"

SkyTouch="$Sky/src/SkyTouch"

#--------------------------------------------------------------------------------------------------

content="../content"

bin="../bin"

#--------------------------------------------------------------------------------------------------
# environment

qt="qt5"

#--------------------------------------------------------------------------------------------------
# Syntax
#--------------------------------------------------------------------------------------------------

if [ $# != 1 -a $# != 2 ] \
   || \
   [ $1 != "win32" -a $1 != "win64" -a $1 != "macOS" -a $1 != "linux" -a $1 != "android" ] \
   || \
   [ $# = 2 -a "$2" != "all" -a "$2" != "deploy" -a "$2" != "clean" ]; then

    echo "Usage: generate <win32 | win64 | macOS | linux | android> [all | deploy | clean]"

    exit 1
fi

#--------------------------------------------------------------------------------------------------
# Configuration
#--------------------------------------------------------------------------------------------------

if [ $1 = "win32" -o $1 = "win64" ]; then

    os="windows"
else
    os="default"
fi

if [ "$2" = "deploy" -o $1 = "android" ]; then

    path="qrc"
else
    path="$bin"
fi

cd ../dist

#--------------------------------------------------------------------------------------------------
# Clean
#--------------------------------------------------------------------------------------------------

if [ "$2" = "clean" ]; then

    echo "CLEANING"

    rm -f  $bin/*.qml
    rm -rf $bin/pictures
    rm -rf $bin/icons
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

if [ $1 = "android" -o "$2" = "all" -o "$2" = "deploy" ]; then

    if [ $qt = "qt6" ]; then

        echo "COPYING shaders"

        cp -r "$Sky"/deploy/shaders $path
    fi

    echo "COPYING pictures"

    cp -r $content/pictures $path

    echo "COPYING icons"

    cp -r $content/icons $path

    if [ $1 = "android" ]; then

        echo "COPYING videos"

        cp -r $content/videos/* ../dist/android/assets/videos

    elif [ "$2" = "all" ]; then

        echo "COPYING videos"

        cp -r $content/videos $path

        rm $path/videos/.gitignore
    fi
fi

#--------------------------------------------------------------------------------------------------
# Icon
#--------------------------------------------------------------------------------------------------

if [ $1 = "macOS" ]; then

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

if [ $qt = "qt4" ]; then

    version=1.1

    defines="QT_4"
else
    if [ $qt = "qt5" ]; then

        defines="QT_5 QT_LATEST"
    else
        defines="QT_6 QT_LATEST"
    fi

    if [ $1 = "linux" ]; then

        version=2.7
    else
        version=2.14
    fi
fi

if [ $os = "windows" ]; then

    defines="$defines DESKTOP WINDOWS"

elif [ $1 = "macOS" ]; then

    defines="$defines DESKTOP MAC"

elif [ $1 = "linux" ]; then

    defines="$defines DESKTOP LINUX"
else
    defines="$defines MOBILE ANDROID"
fi

if [ "$2" = "deploy" ]; then

    defines="$defines DEPLOY"
fi

files="\
$SkyBase/Style.qml \
$SkyBase/WindowSky.qml \
$SkyBase/RectangleBorders.qml \
$SkyBase/TextBase.qml \
$SkyBase/BaseButton.qml \
$SkyTouch/StyleTouch.qml \
$SkyTouch/BaseButtonTouch.qml \
$SkyTouch/ButtonTouch.qml"

"$Sky"/deploy/deployer $path $version qrc/HelloSky.qrc "$defines" $files
