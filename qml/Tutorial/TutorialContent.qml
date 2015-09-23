/*
 * Copyright (C) 2013,2014 Canonical, Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import Ubuntu.Components 1.3
import AccountsService 0.1

Item {
    id: root

    property Item launcher
    property Item panel

    readonly property bool launcherEnabled: !running || tutorialLeft.shown
    readonly property bool spreadEnabled: !running
    readonly property bool panelEnabled: !running || tutorialTop.shown
    readonly property bool panelContentEnabled: !running
    readonly property alias running: d.running

    signal finished()

    function finish() {
        finished();
    }

    ////

    QtObject {
        id: d

        property bool running: tutorialLeft.shown || tutorialTop.shown
    }

    TutorialLeft {
        id: tutorialLeft
        objectName: "tutorialLeft"
        parent: root.panel
        anchors.fill: parent
        launcher: root.launcher

        Component.onCompleted: {
            if (AccountsService.demoEdgesCompleted.indexOf("left") == -1) {
                show();
            }
        }

        onFinished: {
            AccountsService.markDemoEdgeCompleted("left");
        }
    }

    TutorialTop {
        id: tutorialTop
        objectName: "tutorialTop"
        parent: root.panel
        anchors.fill: parent
        panel: root.panel

        Connections {
            target: AccountsService
            onDemoEdgesCompletedChanged: {
                if (AccountsService.demoEdgesCompleted.indexOf("left") != -1 &&
                        AccountsService.demoEdgesCompleted.indexOf("top") == -1) {
                    tutorialTopTimer.start();
                }
            }
        }

        Timer {
            id: tutorialTopTimer
            interval: 1
            onTriggered: tutorialTop.show()
        }

        onFinished: {
            AccountsService.markDemoEdgeCompleted("top");
            root.finish();
        }
    }
}
