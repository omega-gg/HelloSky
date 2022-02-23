#!/bin/sh
set -e

#--------------------------------------------------------------------------------------------------
# Settings
#--------------------------------------------------------------------------------------------------

Sky="../Sky"

external="../3rdparty"

assets="../assets"

#--------------------------------------------------------------------------------------------------

VLC_version="3.0.16"

#--------------------------------------------------------------------------------------------------
# Windows

MinGW_version="8.1.0"

#--------------------------------------------------------------------------------------------------
# Android

JDK_version="8u321"

TOOLS_version="30.0.3"

SDK_version="30"

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
   [ $1 != "win32" -a $1 != "win64" -a $1 != "macOS" -a $1 != "linux" -a $1 != "android" ] \
   || \
   [ $# = 2 -a "$2" != "sky" -a "$2" != "clean" ]; then

    echo "Usage: configure <win32 | win64 | macOS | linux | android> [sky | clean]"

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
    mkdir  bin/plugins

    cp -r "$VLC"/plugins/access             bin/plugins
    cp -r "$VLC"/plugins/audio_filter       bin/plugins
    cp -r "$VLC"/plugins/audio_mixer        bin/plugins
    cp -r "$VLC"/plugins/audio_output       bin/plugins
    cp -r "$VLC"/plugins/codec              bin/plugins
    cp -r "$VLC"/plugins/control            bin/plugins
    cp -r "$VLC"/plugins/demux              bin/plugins
    cp -r "$VLC"/plugins/misc               bin/plugins
    cp -r "$VLC"/plugins/packetizer         bin/plugins
    cp -r "$VLC"/plugins/services_discovery bin/plugins
    cp -r "$VLC"/plugins/stream_filter      bin/plugins
    cp -r "$VLC"/plugins/stream_out         bin/plugins
    cp -r "$VLC"/plugins/video_chroma       bin/plugins
    cp -r "$VLC"/plugins/video_filter       bin/plugins
    cp -r "$VLC"/plugins/video_output       bin/plugins

    cp "$VLC"/libvlc*.dll bin

elif [ $1 = "macOS" ]; then

    echo "COPYING VLC"

    rm -rf bin/plugins
    mkdir  bin/plugins

    cp -r "$VLC"/plugins/*.dylib bin/plugins

    cp "$VLC"/lib/libvlc.5.dylib     bin/libvlc.dylib
    cp "$VLC"/lib/libvlccore.9.dylib bin/libvlccore.dylib

elif [ $1 = "android" ]; then

    echo "COPYING VLC"

    copyAndroid "$VLC"
fi

echo "--------------------"
