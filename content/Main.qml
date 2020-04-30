//=================================================================================================
/*
    Copyright (C) 2015-2020 HelloSky authors united with omega. <http://omega.gg/about>

    Author: Benjamin Arnaud. <http://bunjee.me> <bunjee@omega.gg>

    This file is part of HelloSky.

    - GNU General Public License Usage:
    This file may be used under the terms of the GNU General Public License version 3 as published
    by the Free Software Foundation and appearing in the LICENSE.md file included in the packaging
    of this file. Please review the following information to ensure the GNU General Public License
    requirements will be met: https://www.gnu.org/licenses/gpl.html.
*/
//=================================================================================================

import QtQuick 1.0
import Sky     1.0

Application
{
    id: application

    //---------------------------------------------------------------------------------------------
    // Properties style
    //---------------------------------------------------------------------------------------------

    property url sourceBackground: "pictures/sky.png"
    property url sourceLogo      : "pictures/logoSky.svg"

    //---------------------------------------------------------------------------------------------
    // Functions
    //---------------------------------------------------------------------------------------------

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
    }

    //---------------------------------------------------------------------------------------------
    // Childs
    //---------------------------------------------------------------------------------------------

    Window
    {
        id: window

        st: Style { id: st }

        onKeyPressed:
        {
            if (event.key == Qt.Key_Escape)
            {
                event.accepted = true;

                close();
            }
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
        }

//#DESKTOP
        ViewDrag
        {
            anchors.fill: parent

            onDoubleClicked: window.maximized = !(window.maximized);
        }
//#END

        ImageScale
        {
            anchors.fill: parent

            source: sourceBackground

            fillMode: Image.PreserveAspectCrop

            cache: false
        }

//#QT_4
        ImageSvgScale
//#ELSE
        ImageSvg
//#END
        {
            anchors.centerIn: parent

            width: Math.round(height * 1.5)

            height: (parent.width < st.dp640) ? Math.round(parent.height / 5)
                                              : Math.round(parent.height / 3.272)

            source: sourceLogo
        }

        Text
        {
            anchors.left  : parent.left
            anchors.bottom: parent.bottom

            anchors.margins: st.dp24

            text: "Sky " + sk.versionSky + "\nQt  " + sk.versionQt

            color: "#fafafa"

            font.family   : "consolas"
            font.pixelSize: st.dp16
        }

//#DESKTOP
        Button
        {
            anchors.top  : parent.top
            anchors.right: parent.right

            anchors.margins: st.dp16

            text: qsTr("Exit")

            onClicked: sk.quit()
        }
//#END
    }
}
