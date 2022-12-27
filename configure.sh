#!/bin/sh
set -e

#--------------------------------------------------------------------------------------------------
# Settings
#--------------------------------------------------------------------------------------------------

Sky="../Sky"

external="../3rdparty"

assets="../assets"

#--------------------------------------------------------------------------------------------------

VLC_version="3.0.17.3"

#--------------------------------------------------------------------------------------------------
# Windows

MinGW_version="11.2.0"

#--------------------------------------------------------------------------------------------------
# Android

JDK_version="11.0.2"

TOOLS_version="31.0.0"

SDK_version="31"

#--------------------------------------------------------------------------------------------------
# environment

compiler_win="mingw"

qt="qt5"

#--------------------------------------------------------------------------------------------------
# Functions
#--------------------------------------------------------------------------------------------------

copyAndroid()
{
    cp -r "$1"/armeabi-v7a $data/armeabi-v7a/libs
    cp -r "$1"/arm64-v8a   $data/arm64-v8a/libs
    cp -r "$1"/x86         $data/x86/libs
    cp -r "$1"/x86_64      $data/x86_64/libs
}

cleanAndroid()
{
    path="$data/$1/libs/$1"

    rm -f $path/*.so
    rm -f $path/*.a
}

#--------------------------------------------------------------------------------------------------
# Syntax
#--------------------------------------------------------------------------------------------------

if [ $# != 1 -a $# != 2 ] \
   || \
   [ $1 != "win32" -a $1 != "win64" -a $1 != "macOS" -a $1 != "iOS" -a $1 != "linux" -a \
     $1 != "android" ] \
   || \
   [ $# = 2 -a "$2" != "sky" -a "$2" != "clean" ]; then

    echo "Usage: configure <win32 | win64 | macOS | iOS | linux | android> [sky | clean]"

    exit 1
fi

#--------------------------------------------------------------------------------------------------
# Configuration
#--------------------------------------------------------------------------------------------------

external="$PWD/$external/$1"

if [ $1 = "win32" -o $1 = "win64" ]; then

    os="windows"

    compiler="$compiler_win"

    if [ $compiler = "mingw" ]; then

        MinGW="$external/MinGW/$MinGW_version/bin"
    fi
else
    os="default"

    compiler="default"
fi

VLC="$external/VLC/$VLC_version"

path="$Sky/deploy"

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

if [ $1 = "android" ]; then

    data="dist/android/data"

    cleanAndroid armeabi-v7a
    cleanAndroid arm64-v8a
    cleanAndroid x86
    cleanAndroid x86_64
fi

if [ "$2" = "clean" ]; then

    exit 0
fi

#--------------------------------------------------------------------------------------------------
# Sky
#--------------------------------------------------------------------------------------------------

if [ "$2" = "sky" ]; then

    echo "CONFIGURING Sky"
    echo "---------------"

    cd "$Sky"

    sh configure.sh $1

    cd -

    echo "---------------"
    echo ""
fi

#--------------------------------------------------------------------------------------------------
# assets

cp "$assets"/videos/sky.mp4 content/videos

#--------------------------------------------------------------------------------------------------
# MinGW
#--------------------------------------------------------------------------------------------------

echo "CONFIGURING HelloSky"
echo "--------------------"

if [ $compiler = "mingw" ]; then

    cp "$MinGW"/libgcc_s_*-1.dll    bin
    cp "$MinGW"/libstdc++-6.dll     bin
    cp "$MinGW"/libwinpthread-1.dll bin
fi

#--------------------------------------------------------------------------------------------------
# SDK
#--------------------------------------------------------------------------------------------------

if [ $1 = "android" ]; then

    echo "CONFIGURING SDK"

    cd "$external/SDK/$SDK_version/tools/bin"

    export JAVA_HOME="$external/JDK/$JDK_version"

    path="$PWD/../.."

    yes | ./sdkmanager --sdk_root="$path" --licenses

    ./sdkmanager --sdk_root="$path" "build-tools;$TOOLS_version" \
                                    "platforms;android-$SDK_version" \

    ./sdkmanager --sdk_root="$path" --update

    cd -
fi

#--------------------------------------------------------------------------------------------------
# VLC
#--------------------------------------------------------------------------------------------------

if [ $os = "windows" ]; then

    echo "COPYING VLC"

    rm -rf bin/plugins

    cp -r "$path"/plugins bin

    cp "$path"/libvlc*.dll bin

elif [ $1 = "macOS" ]; then

    echo "COPYING VLC"

    rm -rf bin/plugins

    cp -r "$path"/plugins bin

    cp "$path"/libvlc*.dylib bin

elif [ $1 = "linux" ]; then

    echo "COPYING VLC"

    rm -rf bin/vlc
    mkdir  bin/vlc

    cp -r "$path"/vlc bin

    cp "$path"/libvlc*.so* bin

elif [ $1 = "android" ]; then

    echo "COPYING VLC"

    copyAndroid "$VLC"
fi

echo "--------------------"
