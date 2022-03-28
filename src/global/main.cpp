//=================================================================================================
/*
    Copyright (C) 2015-2020 Sky kit authors. <http://omega.gg/Sky>

    Author: Benjamin Arnaud. <http://bunjee.me> <bunjee@omega.gg>

    This file is part of HelloSky.

    - GNU Lesser General Public License Usage:
    This file may be used under the terms of the GNU Lesser General Public License version 3 as
    published by the Free Software Foundation and appearing in the LICENSE.md file included in the
    packaging of this file. Please review the following information to ensure the GNU Lesser
    General Public License requirements will be met: https://www.gnu.org/licenses/lgpl.html.

    - Private License Usage:
    Sky kit licensees holding valid private licenses may use this file in accordance with the
    private license agreement provided with the Software or, alternatively, in accordance with the
    terms contained in written agreement between you and Sky kit authors. For further information
    contact us at contact@omega.gg.
*/
//=================================================================================================

// Qt includes
#include <QDir>

// Sk includes
#include <WControllerFile>
#include <WControllerDeclarative>
#include <WControllerPlaylist>
#include <WControllerMedia>
#include <WApplication>
#include <WView>
#include <WViewResizer>
#include <WViewDrag>
#include <WWindow>
#include <WBackendVlc>
#include <WImageFilterColor>
#include <WDeclarativeApplication>
#include <WDeclarativeBorders>
#include <WDeclarativeImage>
#include <WDeclarativeImageSvg>
#include <WDeclarativePlayer>

//-------------------------------------------------------------------------------------------------
// Functions
//-------------------------------------------------------------------------------------------------

int main(int argc, char * argv[])
{
    QApplication * application = WApplication::create(argc, argv);

    if (application == NULL) return 0;

    //---------------------------------------------------------------------------------------------
    // Settings
    //---------------------------------------------------------------------------------------------

#ifdef Q_OS_LINUX
    sk->setIcon(":/icons/icon.svg");
#endif

    QString path;

#ifdef SK_DEPLOY
    path = QDir::fromNativeSeparators(WControllerFile::pathWritable());
#else
    path = QDir::currentPath();
#endif

    wControllerFile->setPathStorage(path);

    //---------------------------------------------------------------------------------------------
    // Controllers
    //---------------------------------------------------------------------------------------------

    W_CREATE_CONTROLLER(WControllerPlaylist);
    W_CREATE_CONTROLLER(WControllerMedia);

    //---------------------------------------------------------------------------------------------
    // Log
    //---------------------------------------------------------------------------------------------

    wControllerFile->initMessageHandler();

    //---------------------------------------------------------------------------------------------
    // QML
    //---------------------------------------------------------------------------------------------
    // Global

    qmlRegisterUncreatableType<WControllerDeclarative>("Sky", 1,0, "Sk", "Sk is not creatable");

    //---------------------------------------------------------------------------------------------
    // Application

    qmlRegisterType<WDeclarativeApplication>("Sky", 1,0, "Application");

    //---------------------------------------------------------------------------------------------
    // View

    qmlRegisterUncreatableType<WView>("Sky", 1,0, "View", "View is abstract");

    qmlRegisterType<WViewResizer>("Sky", 1,0, "ViewResizer");
    qmlRegisterType<WViewDrag>   ("Sky", 1,0, "ViewDrag");

    qmlRegisterType<WWindow>("Sky", 1,0, "BaseWindow");

    //---------------------------------------------------------------------------------------------
    // Image

    qmlRegisterType<WImageFilterColor>("Sky", 1,0, "ImageFilterColor");

    //---------------------------------------------------------------------------------------------
    // Declarative

    qmlRegisterType<WDeclarativeBorders>("Sky", 1,0, "Borders");

    qmlRegisterType<WDeclarativeMouseArea>("Sky", 1,0, "MouseArea");

    qmlRegisterType<WDeclarativeGradient>    ("Sky", 1,0, "ScaleGradient");
    qmlRegisterType<WDeclarativeGradientStop>("Sky", 1,0, "ScaleGradientStop");

    qmlRegisterType<WDeclarativeImage>     ("Sky", 1,0, "Image");
    qmlRegisterType<WDeclarativeImageScale>("Sky", 1,0, "ImageScale");
    qmlRegisterType<WDeclarativeImageSvg>  ("Sky", 1,0, "ImageSvg");

#ifdef QT_4
    qmlRegisterType<WDeclarativeImageSvgScale>("Sky", 1,0, "ImageSvgScale");
#endif

    qmlRegisterType<WDeclarativePlayer>("Sky", 1,0, "Player");

    //---------------------------------------------------------------------------------------------
    // Multimedia

    qmlRegisterUncreatableType<WAbstractBackend>("Sky", 1,0, "AbstractBackend",
                                                 "AbstractBackend is abstract");

    qmlRegisterType<WBackendVlc>("Sky", 1,0, "BackendVlc");

    //---------------------------------------------------------------------------------------------
    // Events

    qmlRegisterUncreatableType<WDeclarativeKeyEvent>("Sky", 1,0, "DeclarativeKeyEvent",
                                                     "DeclarativeKeyEvent is not creatable");

    //---------------------------------------------------------------------------------------------
    // Context

    wControllerDeclarative->setContextProperty("sk",             sk);
    wControllerDeclarative->setContextProperty("controllerFile", wControllerFile);

#ifdef Q_OS_ANDROID
    //---------------------------------------------------------------------------------------------
    // Assets
    //---------------------------------------------------------------------------------------------
    // FIXME android: We copy the assets to a writable location to provide an URI to libVLC.

    QString fileName = path + "/sky.mp4";

    if (QFile::exists(fileName) == false)
    {
        WControllerFile::copyFile("assets:/videos/sky.mp4", fileName);
    }
#endif

#ifndef SK_DEPLOY
    sk->setQrc(false);
#endif

    sk->startScript();

    return application->exec();
}
