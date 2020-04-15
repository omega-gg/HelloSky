#!/bin/sh
set -e

#--------------------------------------------------------------------------------------------------
# Settings
#--------------------------------------------------------------------------------------------------

Sky="../Sky"

#--------------------------------------------------------------------------------------------------
# Syntax
#--------------------------------------------------------------------------------------------------

if [ $# != 2 ] || [ $1 != "qt4" -a $1 != "qt5" -a $1 != "clean" ] || [ $2 != "win32" -a \
                                                                       $2 != "win64" -a \
                                                                       $2 != "macOS" -a \
                                                                       $2 != "linux" -a \
                                                                       $2 != "android" ]; then

    echo "Usage: deploy <qt4 | qt5 | clean> <win32 | win64 | macOS | linux | android>"

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

echo "CLEANING"

rm -rf deploy/*

touch deploy/.gitignore

if [ $1 = "clean" ]; then

    exit 0
fi

echo ""

#--------------------------------------------------------------------------------------------------
# Sky
#--------------------------------------------------------------------------------------------------

echo "COPYING Sky"

path="$Sky/deploy"

if [ $os = "windows" ]; then

    cp "$path"/libgcc_s_*-1.dll    deploy
    cp "$path"/libstdc++-6.dll     deploy
    cp "$path"/libwinpthread-1.dll deploy

    if [ $1 = "qt4" ]; then

        mkdir deploy/imageformats

        cp "$path"/QtCore4.dll        deploy
        cp "$path"/QtGui4.dll         deploy
        cp "$path"/QtDeclarative4.dll deploy
        cp "$path"/QtNetwork4.dll     deploy
        cp "$path"/QtOpenGL4.dll      deploy
        cp "$path"/QtScript4.dll      deploy
        cp "$path"/QtSql4.dll         deploy
        cp "$path"/QtSvg4.dll         deploy
        cp "$path"/QtWebKit4.dll      deploy
        cp "$path"/QtXml4.dll         deploy
        cp "$path"/QtXmlPatterns4.dll deploy

        cp "$path"/imageformats/qsvg4.so  deploy/imageformats
        cp "$path"/imageformats/qjpeg4.so deploy/imageformats
    else
        mkdir deploy/platforms
        mkdir deploy/imageformats
        mkdir deploy/QtQuick.2

        cp "$path"/libEGL.dll    deploy
        cp "$path"/libGLESv2.dll deploy

        cp "$path"/Qt5Core.dll        deploy
        cp "$path"/Qt5Gui.dll         deploy
        cp "$path"/Qt5Network.dll     deploy
        cp "$path"/Qt5OpenGL.dll      deploy
        cp "$path"/Qt5Qml.dll         deploy
        cp "$path"/Qt5Quick.dll       deploy
        cp "$path"/Qt5Svg.dll         deploy
        cp "$path"/Qt5Widgets.dll     deploy
        cp "$path"/Qt5Xml.dll         deploy
        cp "$path"/Qt5XmlPatterns.dll deploy
        cp "$path"/Qt5WinExtras.dll   deploy

        if [ -f "$path"/Qt5QmlModels.dll ]; then

            cp "$path"/Qt5QmlModels.dll       deploy
            cp "$path"/Qt5QmlWorkerScript.dll deploy
        fi

        cp "$path"/platforms/qwindows.dll deploy/platforms

        cp "$path"/imageformats/qsvg.dll  deploy/imageformats
        cp "$path"/imageformats/qjpeg.dll deploy/imageformats

        cp "$path"/QtQuick.2/qtquick2plugin.dll deploy/QtQuick.2
        cp "$path"/QtQuick.2/qmldir             deploy/QtQuick.2
    fi

elif [ $2 = "macOS" ]; then

    if [ $1 = "qt5" ]; then

        mkdir deploy/platforms
        mkdir deploy/imageformats
        mkdir deploy/QtQuick.2

        cp "$path"/QtCore.dylib        deploy
        cp "$path"/QtNetwork.dylib     deploy
        cp "$path"/QtXml.dylib         deploy
        cp "$path"/QtXmlPatterns.dylib deploy
    fi

elif [ $2 = "linux" ]; then

    if [ $1 = "qt4" ]; then

        mkdir deploy/imageformats

        cp "$path"/libQtCore.so.4        deploy
        cp "$path"/libQtNetwork.so.4     deploy
        cp "$path"/libQtScript.so.4      deploy
        cp "$path"/libQtXml.so.4         deploy
        cp "$path"/libQtXmlPatterns.so.4 deploy
    else
        mkdir deploy/platforms
        mkdir deploy/imageformats
        mkdir deploy/QtQuick.2

        cp "$path"/libQt5Core.so.5        deploy
        cp "$path"/libQt5Network.so.5     deploy
        cp "$path"/libQt5Xml.so.5         deploy
        cp "$path"/libQt5XmlPatterns.so.5 deploy
    fi
fi

#--------------------------------------------------------------------------------------------------
# HelloSky
#--------------------------------------------------------------------------------------------------

echo "COPYING HelloSky"

if [ $2 = "macOS" ]; then

    cp bin/HelloSky deploy

    cd deploy

    #----------------------------------------------------------------------------------------------
    # Qt

    install_name_tool -change @rpath/QtCore.framework/Versions/5/QtCore \
                              @loader_path/QtCore.dylib HelloSky

    install_name_tool -change @rpath/QtNetwork.framework/Versions/5/QtNetwork \
                              @loader_path/QtNetwork.dylib HelloSky

    install_name_tool -change @rpath/QtQml.framework/Versions/5/QtQml \
                              @loader_path/QtQml.dylib HelloSky

    install_name_tool -change @rpath/QtXml.framework/Versions/5/QtXml \
                              @loader_path/QtXml.dylib HelloSky

    install_name_tool -change @rpath/QtXmlPatterns.framework/Versions/5/QtXmlPatterns \
                              @loader_path/QtXmlPatterns.dylib HelloSky

    #----------------------------------------------------------------------------------------------

    cd -

elif [ $2 = "android" ]; then

    cp bin/libHelloSky* deploy
else
    cp bin/HelloSky* deploy
fi
