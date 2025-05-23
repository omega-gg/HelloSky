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

import QtQuick 1.0
import Sky     1.0

Application
{
    id: application

    //---------------------------------------------------------------------------------------------
    // Properties
    //---------------------------------------------------------------------------------------------
    // Style

    property url sourceBackground: "pictures/sky.png"
    property url sourceLogo      : "pictures/logo.svg"

//#!DEPLOY+MAC
// NOTE macOS: We want to get a path outside the application bundle.
//#QT_OLD
    property url sourceVideo: controllerFile.pathStorage + "/videos/sky.mp4"
//#ELSE
    property url sourceVideo: Qt.resolvedUrl(controllerFile.pathStorage + "/videos/sky.mp4")
//#END
//#ELIF ANDROID
    property url sourceVideo: "file://" + controllerFile.pathStorage + "/sky.mp4"
//#ELSE
    property url sourceVideo: controllerFile.applicationFileUrl("videos/sky.mp4")
//#END

    //---------------------------------------------------------------------------------------------
    // Functions
    //---------------------------------------------------------------------------------------------

//#!DEPLOY
    function takeShot()
    {
        var width = 1024;

        window.width  = width;
        window.height = width * 0.5625; // 16:9 ratio

        sk.wait(1000);

        var path = "../dist/pictures/HelloSky.png";

        window.saveShot(path);

        window.compressShot(path);

        window.setDefaultGeometry();

        //-----------------------------------------------------------------------------------------
        // iOS

        window.borderSize = 0;

//#DESKTOP
        button.visible = false;
//#END

        path = "../dist/pictures/iOS";

        st.ratio = 3.0;

        saveShot(path + "/HelloSkyA.jpg", -1, 1242, 2688);
        saveShot(path + "/HelloSkyB.jpg", -1, 1242, 2208);

        st.ratio = 2.0;

        saveShot(path + "/HelloSkyC.jpg", -1, 2732, 2048);

        //-----------------------------------------------------------------------------------------
        // Android

        path = "../dist/pictures/android";

        st.ratio = 1.0;

        saveShot(path + "/HelloSky.jpg", 90, 1024, 500);

        st.ratio = 3.497;

        saveShot(path + "/HelloSkyMobileA.jpg", -1, 1440, 2560);
        saveShot(path + "/HelloSkyMobileB.jpg", -1, 2560, 1440);

        window.close();
    }

    function saveShot(path, quality, width, height)
    {
        window.width  = width;
        window.height = height;

        sk.wait(1000);

        window.saveShot(path, 0, 0, -1, -1, "jpg", quality);
    }
//#END

    //---------------------------------------------------------------------------------------------
    // Children
    //---------------------------------------------------------------------------------------------

    WindowSky
    {
        id: window

        st: StyleTouch { id: st }

//#ANDROID
        Component.onCompleted: hideSplash()
//#END

//#MOBILE
        onDoubleClicked:
        {
            if (fullScreen)
            {
                fullScreen = false;

                sk.requestLandscape(false);
            }
            else
            {
                fullScreen = true;

                sk.requestLandscape(true);
            }
        }
//#END

        /* QML_EVENT */ onKeyPressed: function(event)
        {
            if (event.key == Qt.Key_Escape)
            {
                event.accepted = true;

                close();
            }
//#!DEPLOY
            else if (event.key == Qt.Key_F1)
            {
                event.accepted = true;

                sk.restartScript();
            }
            else if (event.key == Qt.Key_F12)
            {
                event.accepted = true;

                application.takeShot();
            }
//#END
        }

//#DESKTOP
        ViewDrag
        {
            anchors.fill: parent

            onDoubleClicked: window.maximized = !(window.maximized)
        }
//#END

        ImageScale
        {
            anchors.fill: parent

            visible: (player.visible == false)

            source: sourceBackground

            fillMode: Image.PreserveAspectCrop

            cache: false
        }

        Player
        {
            id: player

            anchors.fill: parent

            visible: (isLoading == false && isPlaying)

            backend: BackendVlc {}

            source: sourceVideo

            volume: 0.0

            fillMode: AbstractBackend.PreserveAspectCrop
        }

//#QT_4
        ImageSvgScale
//#ELSE
        ImageSvg
//#END
        {
            anchors.centerIn: parent

            width: Math.round(height * 1.5)

            height: (st.isTight) ? Math.round(parent.height / 5)
                                 : Math.round(parent.height / 3.272)

            source: sourceLogo
        }

        TextBase
        {
            id: itemText

            anchors.left  : parent.left
            anchors.bottom: parent.bottom

            anchors.margins: st.dp24

            text: "Sky " + sk.versionSky + "\nQt  " + sk.versionQt + "\nVLC "
                  + controllerMedia.versionVlc

            color: st.text2_color

            font.family   : "consolas"
            font.pixelSize: st.dp18
        }

//#QT_6
        TextBase
        {
            anchors.right : parent.right
            anchors.bottom: parent.bottom

            anchors.margins: itemText.anchors.margins

            text: window.graphicsApiName()

            color: itemText.color

            font: itemText.font
        }
//#END

        ButtonTouch
        {
            anchors.left: parent.left
            anchors.top : parent.top

            anchors.margins: st.dp16

            text: (player.visible) ? qsTr("Stop Video")
                                   : qsTr("Start Video")

            onClicked: player.togglePlay()
        }

//#DESKTOP
        ButtonTouch
        {
            id: button

            anchors.right: parent.right
            anchors.top  : parent.top

            anchors.margins: st.dp16

            text: qsTr("Exit")

//#QT_4
            onClicked: sk.quit()
//#ELSE
            onClicked: Qt.callLater(sk.quit);
//#END
        }
//#END
    }
}
