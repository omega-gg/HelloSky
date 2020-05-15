#!/bin/sh
set -e

#--------------------------------------------------------------------------------------------------
# Settings
#--------------------------------------------------------------------------------------------------

Sky="../Sky"

external="../3rdparty"

#--------------------------------------------------------------------------------------------------
# Windows

MinGW_version="7.3.0"

#--------------------------------------------------------------------------------------------------
# Android

JDK_version="8u251"

TOOLS_version="30.0.0-rc3"

SDK_version="29"

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
   [ $# = 3 -a "$3" != "sky" ]; then

    echo "Usage: configure <qt4 | qt5 | clean>"
    echo "                 <win32 | win64 | win32-msvc | win64-msvc | macOS | linux | android>"
    echo "                 [sky]"

    exit 1
fi

#--------------------------------------------------------------------------------------------------
# Configuration
#--------------------------------------------------------------------------------------------------

external="$PWD/$external/$2"

if [ $2 = "win32" -o $2 = "win64" ]; then

    compiler="mingw"

    MinGW="$external/MinGW/$MinGW_version/bin"
else
    compiler="default"
fi

#--------------------------------------------------------------------------------------------------
# Clean
#--------------------------------------------------------------------------------------------------

echo "CLEANING"

rm -rf bin/*
touch  bin/.gitignore

# NOTE: We have to remove the folder to delete .qmake.stash.
rm -rf build
mkdir  build
touch  build/.gitignore

if [ $1 = "clean" ]; then

    exit 0
fi

#--------------------------------------------------------------------------------------------------
# Sky
#--------------------------------------------------------------------------------------------------

if [ "$3" = "sky" ]; then

    echo "CONFIGURING Sky"
    echo "---------------"

    cd "$Sky"

    sh configure.sh $1 $2

    cd -

    echo "---------------"
    echo ""
fi

#--------------------------------------------------------------------------------------------------
# MinGW
#--------------------------------------------------------------------------------------------------

echo "CONFIGURING HelloSky"

if [ $compiler = "mingw" ]; then

    cp "$MinGW"/libgcc_s_*-1.dll    bin
    cp "$MinGW"/libstdc++-6.dll     bin
    cp "$MinGW"/libwinpthread-1.dll bin
fi

#--------------------------------------------------------------------------------------------------
# SDK
#--------------------------------------------------------------------------------------------------

if [ $2 = "android" ]; then

    echo "CONFIGURING SDK"

    cd "$external/SDK/$SDK_version/tools/bin"

    path="$PWD/../.."

    yes | ./sdkmanager --sdk_root="$path" --licenses

    ./sdkmanager --sdk_root="$path" "build-tools;$TOOLS_version" \
                                    "platforms;android-$SDK_version" \

    ./sdkmanager --sdk_root="$path" --update

    cd -
fi
