//=================================================================================================
/*
    Copyright (C) 2015-2020 MotionBox authors united with omega. <http://omega.gg/about>

    Author: Benjamin Arnaud. <http://bunjee.me> <bunjee@omega.gg>

    This file is part of MotionBox.

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
    //---------------------------------------------------------------------------------------------
    // Childs
    //---------------------------------------------------------------------------------------------

    Window
    {
        st: Style
        {
            id: st

            //border_size : dp8
            //border_color: "#161616"
        }

        onKeyPressed:
        {
            if (event.key == Qt.Key_Escape)
            {
                event.accepted = true;

                close();
            }
        }

        ImageScale
        {
            anchors.fill: parent

            source: "pictures/sky.png"

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

            width : Math.round(parent.width / 4)
            height: Math.round(width        / 1.454)

            source: "pictures/logoSky.svg"
        }
    }
}
