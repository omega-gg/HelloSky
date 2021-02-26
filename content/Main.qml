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

//#ANDROID
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
        // Android

        window.borderSize = 0;

//#DESKTOP
        button.visible = false;
//#END

        st.ratio = 1.0;

        window.width  = 1024;
        window.height = 500;

        sk.wait(1000);

        path = "../dist/pictures/android";

        saveShot(path + "/HelloSky.jpg", 90);

        st.ratio = 3.497;

        window.width  = 1440;
        window.height = 2560;

        sk.wait(1000);

        saveShot(path + "/HelloSkyMobileA.jpg", -1);

        window.width  = 2560;
        window.height = 1440;

        sk.wait(1000);

        saveShot(path + "/HelloSkyMobileB.jpg", -1);

        window.close();
    }

    function saveShot(path, quality)
    {
        window.saveShot(path, 0, 0, -1, -1, "jpg", quality);
    }
//#END

    //---------------------------------------------------------------------------------------------
    // Childs
    //---------------------------------------------------------------------------------------------

    Window
    {
        id: window

        st: StyleTouch { id: st }

//#ANDROID
        Component.onCompleted: hideSplash()
//#END

//#MOBILE
        onDoubleClicked: fullScreen = !(fullScreen)
//#END

        onKeyPressed:
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
            anchors.left  : parent.left
            anchors.bottom: parent.bottom

            anchors.margins: st.dp24

            text: "Sky " + sk.versionSky + "\nQt  " + sk.versionQt

            color: st.text2_color

            font.family   : "consolas"
            font.pixelSize: st.dp18
        }

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

            onClicked: sk.quit()
        }
//#END
    }
}
