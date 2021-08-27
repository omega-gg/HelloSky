#!/bin/sh
set -e

#--------------------------------------------------------------------------------------------------
# Settings
#--------------------------------------------------------------------------------------------------

target="HelloSky"

Sky="../Sky"

#--------------------------------------------------------------------------------------------------
# environment

compiler_win="mingw"

qt="qt5"

#--------------------------------------------------------------------------------------------------
# Syntax
#--------------------------------------------------------------------------------------------------

if [ $# != 1 -a $# != 2 ] \
   || \
   [ $1 != "win32" -a $1 != "win64" -a $1 != "macOS" -a $1 != "linux" -a $1 != "android" ] \
   || \
   [ $# = 2 -a "$2" != "clean" ]; then

    echo "Usage: deploy <win32 | win64 | macOS | linux | android> [clean]"

    exit 1
fi

#--------------------------------------------------------------------------------------------------
# Configuration
#--------------------------------------------------------------------------------------------------

if [ $1 = "win32" -o $1 = "win64" ]; then

    os="windows"

    compiler="$compiler_win"
else
    os="default"

    compiler="default"
fi

#--------------------------------------------------------------------------------------------------
# Clean
#--------------------------------------------------------------------------------------------------

echo "CLEANING"

rm -rf deploy/*

touch deploy/.gitignore

if [ "$2" = "clean" ]; then

    exit 0
fi

echo ""

#--------------------------------------------------------------------------------------------------
# Bundle
#--------------------------------------------------------------------------------------------------

if [ $1 = "macOS" ]; then

    cp -r bin/$target.app deploy

    deploy="deploy/$target.app/Contents/MacOS"
else
    deploy="deploy"
fi

#--------------------------------------------------------------------------------------------------
# Sky
#--------------------------------------------------------------------------------------------------

echo "DEPLOYING Sky"
echo "-------------"

cd "$Sky"

sh deploy.sh $1 tools

cd -

path="$Sky/deploy"

#--------------------------------------------------------------------------------------------------
# Qt
#--------------------------------------------------------------------------------------------------

if [ $os = "windows" ]; then

    if [ $compiler = "mingw" ]; then

        cp "$path"/libgcc_s_*-1.dll    $deploy
        cp "$path"/libstdc++-6.dll     $deploy
        cp "$path"/libwinpthread-1.dll $deploy
    fi

    if [ $qt = "qt4" ]; then

        mkdir $deploy/imageformats

        cp "$path"/QtCore4.dll        $deploy
        cp "$path"/QtGui4.dll         $deploy
        cp "$path"/QtDeclarative4.dll $deploy
        cp "$path"/QtNetwork4.dll     $deploy
        cp "$path"/QtOpenGL4.dll      $deploy
        cp "$path"/QtScript4.dll      $deploy
        cp "$path"/QtSql4.dll         $deploy
        cp "$path"/QtSvg4.dll         $deploy
        cp "$path"/QtWebKit4.dll      $deploy
        cp "$path"/QtXml4.dll         $deploy
        cp "$path"/QtXmlPatterns4.dll $deploy

        cp "$path"/imageformats/qsvg4.dll  $deploy/imageformats
        cp "$path"/imageformats/qjpeg4.dll $deploy/imageformats
    else
        mkdir $deploy/platforms
        mkdir $deploy/imageformats
        mkdir $deploy/QtQuick.2

        cp "$path"/libEGL.dll    $deploy
        cp "$path"/libGLESv2.dll $deploy

        cp "$path"/Qt5Core.dll        $deploy
        cp "$path"/Qt5Gui.dll         $deploy
        cp "$path"/Qt5Network.dll     $deploy
        cp "$path"/Qt5OpenGL.dll      $deploy
        cp "$path"/Qt5Qml.dll         $deploy
        cp "$path"/Qt5Quick.dll       $deploy
        cp "$path"/Qt5Svg.dll         $deploy
        cp "$path"/Qt5Widgets.dll     $deploy
        cp "$path"/Qt5Xml.dll         $deploy
        cp "$path"/Qt5XmlPatterns.dll $deploy
        cp "$path"/Qt5WinExtras.dll   $deploy

        if [ -f "$path"/Qt5QmlModels.dll ]; then

            cp "$path"/Qt5QmlModels.dll       $deploy
            cp "$path"/Qt5QmlWorkerScript.dll $deploy
        fi

        cp "$path"/platforms/qwindows.dll $deploy/platforms

        cp "$path"/imageformats/qsvg.dll  $deploy/imageformats
        cp "$path"/imageformats/qjpeg.dll $deploy/imageformats

        cp "$path"/QtQuick.2/qtquick2plugin.dll $deploy/QtQuick.2
        cp "$path"/QtQuick.2/qmldir             $deploy/QtQuick.2
    fi

elif [ $1 = "macOS" ]; then

    if [ $qt = "qt5" ]; then

        mkdir $deploy/platforms
        mkdir $deploy/imageformats
        mkdir $deploy/QtQuick.2

        # FIXME Qt 5.14 macOS: We have to copy qt.conf to avoid a segfault.
        cp "$path"/qt.conf $deploy

        cp "$path"/QtCore.dylib         $deploy
        cp "$path"/QtGui.dylib          $deploy
        cp "$path"/QtNetwork.dylib      $deploy
        cp "$path"/QtOpenGL.dylib       $deploy
        cp "$path"/QtCore.dylib         $deploy
        cp "$path"/QtQml.dylib          $deploy
        cp "$path"/QtQuick.dylib        $deploy
        cp "$path"/QtSvg.dylib          $deploy
        cp "$path"/QtWidgets.dylib      $deploy
        cp "$path"/QtXml.dylib          $deploy
        cp "$path"/QtXmlPatterns.dylib  $deploy
        cp "$path"/QtDBus.dylib         $deploy
        cp "$path"/QtPrintSupport.dylib $deploy

        if [ -f "$path"/QtQmlModels.dylib ]; then

            cp "$path"/QtQmlModels.dylib       $deploy
            cp "$path"/QtQmlWorkerScript.dylib $deploy
        fi

        cp "$path"/platforms/libqcocoa.dylib $deploy/platforms

        cp "$path"/imageformats/libqsvg.dylib  $deploy/imageformats
        cp "$path"/imageformats/libqjpeg.dylib $deploy/imageformats

        cp "$path"/QtQuick.2/libqtquick2plugin.dylib $deploy/QtQuick.2
        cp "$path"/QtQuick.2/qmldir                  $deploy/QtQuick.2
    fi

elif [ $1 = "linux" ]; then

    if [ $qt = "qt4" ]; then

        mkdir $deploy/imageformats

        cp "$path"/libpng16.so.16 $deploy

        cp "$path"/libQtCore.so.4        $deploy
        cp "$path"/libQtGui.so.4         $deploy
        cp "$path"/libQtDeclarative.so.4 $deploy
        cp "$path"/libQtNetwork.so.4     $deploy
        cp "$path"/libQtOpenGL.so.4      $deploy
        cp "$path"/libQtScript.so.4      $deploy
        cp "$path"/libQtSql.so.4         $deploy
        cp "$path"/libQtSvg.so.4         $deploy
        cp "$path"/libQtWebKit.so.4      $deploy
        cp "$path"/libQtXml.so.4         $deploy
        cp "$path"/libQtXmlPatterns.so.4 $deploy

        cp "$path"/imageformats/libqsvg.so  $deploy/imageformats
        cp "$path"/imageformats/libqjpeg.so $deploy/imageformats
    else
        mkdir $deploy/platforms
        mkdir $deploy/imageformats
        mkdir $deploy/QtQuick.2
        mkdir $deploy/xcbglintegrations

        cp "$path"/libz.so.* $deploy

        cp "$path"/libicudata.so.* $deploy
        cp "$path"/libicui18n.so.* $deploy
        cp "$path"/libicuuc.so.*   $deploy

        cp "$path"/libdouble-conversion.so.* $deploy
        cp "$path"/libpng16.so.*             $deploy
        cp "$path"/libharfbuzz.so.*          $deploy
        cp "$path"/libxcb-xinerama.so.*      $deploy

        # NOTE: Required for Ubuntu 20.04.
        if [ -f "$path"/libpcre2-16.so.0 ]; then

            cp "$path"/libpcre2-16.so.0 $deploy
        fi

        cp "$path"/libQt5Core.so.5        $deploy
        cp "$path"/libQt5Gui.so.5         $deploy
        cp "$path"/libQt5Network.so.5     $deploy
        cp "$path"/libQt5OpenGL.so.5      $deploy
        cp "$path"/libQt5Qml.so.5         $deploy
        cp "$path"/libQt5Quick.so.5       $deploy
        cp "$path"/libQt5Svg.so.5         $deploy
        cp "$path"/libQt5Widgets.so.5     $deploy
        cp "$path"/libQt5Xml.so.5         $deploy
        cp "$path"/libQt5XmlPatterns.so.5 $deploy
        cp "$path"/libQt5XcbQpa.so.5      $deploy
        cp "$path"/libQt5DBus.so.5        $deploy

        if [ -f "$path"/libQt5QmlModels.so.5 ]; then

            cp "$path"/libQt5QmlModels.so.5       $deploy
            cp "$path"/libQt5QmlWorkerScript.so.5 $deploy
        fi

        cp "$path"/platforms/libqxcb.so $deploy/platforms

        cp "$path"/imageformats/libqsvg.so  $deploy/imageformats
        cp "$path"/imageformats/libqjpeg.so $deploy/imageformats

        cp "$path"/xcbglintegrations/libqxcb-egl-integration.so $deploy/xcbglintegrations
        cp "$path"/xcbglintegrations/libqxcb-glx-integration.so $deploy/xcbglintegrations

        cp "$path"/QtQuick.2/libqtquick2plugin.so $deploy/QtQuick.2
        cp "$path"/QtQuick.2/qmldir               $deploy/QtQuick.2
    fi
fi

#--------------------------------------------------------------------------------------------------
# VLC
#--------------------------------------------------------------------------------------------------

if [ $os = "windows" ]; then

    cp -r "$path"/plugins $deploy

    cp "$path"/libvlc*.dll $deploy

elif [ $1 = "macOS" ]; then

    cp -r "$path"/plugins $deploy

    cp "$path"/libvlc*.dylib $deploy
fi

echo "-------------"
echo ""

#--------------------------------------------------------------------------------------------------
# HelloSky
#--------------------------------------------------------------------------------------------------

echo "COPYING $target"

if [ $os = "windows" ]; then

    cp bin/$target.exe $deploy

elif [ $1 = "macOS" ]; then

    cd $deploy

    #----------------------------------------------------------------------------------------------
    # Qt

    install_name_tool -change @rpath/QtCore.framework/Versions/5/QtCore \
                              @loader_path/QtCore.dylib $target

    install_name_tool -change @rpath/QtGui.framework/Versions/5/QtGui \
                              @loader_path/QtGui.dylib $target

    install_name_tool -change @rpath/QtNetwork.framework/Versions/5/QtNetwork \
                              @loader_path/QtNetwork.dylib $target

    install_name_tool -change @rpath/QtOpenGL.framework/Versions/5/QtOpenGL \
                              @loader_path/QtOpenGL.dylib $target

    install_name_tool -change @rpath/QtQml.framework/Versions/5/QtQml \
                              @loader_path/QtQml.dylib $target

    if [ -f QtQmlModels.dylib ]; then

        install_name_tool -change @rpath/QtQmlModels.framework/Versions/5/QtQmlModels \
                                  @loader_path/QtQmlModels.dylib $target
    fi

    install_name_tool -change @rpath/QtQuick.framework/Versions/5/QtQuick \
                              @loader_path/QtQuick.dylib $target

    install_name_tool -change @rpath/QtSvg.framework/Versions/5/QtSvg \
                              @loader_path/QtSvg.dylib $target

    install_name_tool -change @rpath/QtWidgets.framework/Versions/5/QtWidgets \
                              @loader_path/QtWidgets.dylib $target

    install_name_tool -change @rpath/QtXml.framework/Versions/5/QtXml \
                              @loader_path/QtXml.dylib $target

    install_name_tool -change @rpath/QtXmlPatterns.framework/Versions/5/QtXmlPatterns \
                              @loader_path/QtXmlPatterns.dylib $target

    #----------------------------------------------------------------------------------------------
    # platforms

    install_name_tool -change @rpath/QtCore.framework/Versions/5/QtCore \
                              @loader_path/../QtCore.dylib platforms/libqcocoa.dylib

    install_name_tool -change @rpath/QtGui.framework/Versions/5/QtGui \
                              @loader_path/../QtGui.dylib platforms/libqcocoa.dylib

    install_name_tool -change @rpath/QtWidgets.framework/Versions/5/QtWidgets \
                              @loader_path/../QtWidgets.dylib platforms/libqcocoa.dylib

    install_name_tool -change @rpath/QtDBus.framework/Versions/5/QtDBus \
                              @loader_path/../QtDBus.dylib platforms/libqcocoa.dylib

    install_name_tool -change @rpath/QtPrintSupport.framework/Versions/5/QtPrintSupport \
                              @loader_path/../QtPrintSupport.dylib platforms/libqcocoa.dylib

    #----------------------------------------------------------------------------------------------
    # imageformats

    install_name_tool -change @rpath/QtCore.framework/Versions/5/QtCore \
                              @loader_path/../QtCore.dylib imageformats/libqjpeg.dylib

    install_name_tool -change @rpath/QtGui.framework/Versions/5/QtGui \
                              @loader_path/../QtGui.dylib imageformats/libqjpeg.dylib

    #----------------------------------------------------------------------------------------------

    install_name_tool -change @rpath/QtCore.framework/Versions/5/QtCore \
                              @loader_path/../QtCore.dylib imageformats/libqsvg.dylib

    install_name_tool -change @rpath/QtGui.framework/Versions/5/QtGui \
                              @loader_path/../QtGui.dylib imageformats/libqsvg.dylib

    install_name_tool -change @rpath/QtWidgets.framework/Versions/5/QtWidgets \
                              @loader_path/../QtWidgets.dylib imageformats/libqsvg.dylib

    install_name_tool -change @rpath/QtSvg.framework/Versions/5/QtSvg \
                              @loader_path/../QtSvg.dylib imageformats/libqsvg.dylib

    #----------------------------------------------------------------------------------------------
    # QtQuick.2

    install_name_tool -change @rpath/QtGui.framework/Versions/5/QtGui \
                              @loader_path/../QtGui.dylib QtQuick.2/libqtquick2plugin.dylib

    install_name_tool -change @rpath/QtQml.framework/Versions/5/QtQml \
                              @loader_path/../QtQml.dylib QtQuick.2/libqtquick2plugin.dylib

    install_name_tool -change @rpath/QtQuick.framework/Versions/5/QtQuick \
                              @loader_path/../QtQuick.dylib QtQuick.2/libqtquick2plugin.dylib

    if [ -f QtQmlModels.dylib ]; then

        install_name_tool -change @rpath/QtQmlModels.framework/Versions/5/QtQmlModels \
                                  @loader_path/../QtQmlModels.dylib \
                                  QtQuick.2/libqtquick2plugin.dylib

        install_name_tool -change @rpath/QtQmlWorkerScript.framework/Versions/5/QtQmlWorkerScript \
                                  @loader_path/../QtQmlWorkerScript.dylib \
                                  QtQuick.2/libqtquick2plugin.dylib
    fi

    #----------------------------------------------------------------------------------------------
    # VLC

    install_name_tool -change @rpath/libvlccore.dylib \
                              @loader_path/libvlccore.dylib libvlc.dylib

    #----------------------------------------------------------------------------------------------

    cd -

elif [ $1 = "linux" ]; then

    cp bin/$target $deploy

elif [ $1 = "android" ]; then

    path="build/android-build/build/outputs"

    cp $path/apk/release/android-build-release-unsigned.apk $deploy/$target.apk

    cp $path/bundle/release/android-build-release.aab $deploy/$target.aab
fi

if [ $1 != "android" ]; then

    mkdir -p $path

    cp -r content/videos $deploy

    rm $deploy/videos/.gitignore
fi
