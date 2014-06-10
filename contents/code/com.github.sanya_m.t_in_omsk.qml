// -*- coding: iso-8859-1 -*-
/*
 *   Author: Alexander Mezin <mezin.alexander@gmail.com>
 *   Date: ср дек 25 2013, 21:16:09
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents

Item {
    id: root

    function response() {
        if (request.readyState != 4) {
            return
        }
        var text = request.responseText
        if (text == null) {
            return
        }
        var matches = text.match(/"([^".]+)[".]/)
        if (matches == null || matches.length != 2) {
            return
        }
        label.text = matches[1] + "°C"
    }

    function action_refresh() {
        if (request.readyState != 0 && request.readyState != 4) {
            return
        }

        request.open("GET", "http://dove.omsk.otpbank.ru/files/weather.js");
        request.send(null);
    }

    Component.onCompleted: {
        request = new XMLHttpRequest()
        request.onreadystatechange = response
        label.text = "?"

        action_refresh()

        plasmoid.setAction("refresh", "Refresh")
    }

    PlasmaComponents.Label {
        id: label
        anchors.centerIn: parent
        style: Text.Raised;
        font.pixelSize: root.height * 0.5
    }

    PlasmaCore.ToolTip {
        target: root
        mainText: "Temperature in Omsk"
        subText: label.text
        image: "weather-freezing-rain"
    }
    
    Timer {
        interval: 5 * 60 * 1000
        running: true
        repeat: true
        onTriggered: action_refresh()
    }

    MouseArea {
        anchors.fill: parent
        onClicked: action_refresh()
    }
}
