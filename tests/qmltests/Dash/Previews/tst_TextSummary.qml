/*
 * Copyright 2014 Canonical Ltd.
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

import QtQuick 2.0
import QtTest 1.0
import Ubuntu.Components 0.1
import "../../../../qml/Dash/Previews"
import Unity.Test 0.1 as UT

Rectangle {
    id: root
    width: units.gu(40)
    height: units.gu(80)
    color: Theme.palette.selected.background

    property var widgetDataComplete: {
        "title": "Title here",
        "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.\nPhasellus a mi vitae augue rhoncus lobortis ut rutrum metus.\nCurabitur tortor leo, tristique sed mollis quis, condimentum venenatis nibh.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit.\nPhasellus a mi vitae augue rhoncus lobortis ut rutrum metus.\nCurabitur tortor leo, tristique sed mollis quis, condimentum venenatis nibh."
    }

    property var widgetDataShortText: {
        "title": "Title here",
        "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.\nPhasellus a mi vitae augue rhoncus lobortis ut rutrum metus.\nCurabitur tortor leo, tristique sed mollis quis, condimentum venenatis nibh."
}

    property var widgetDataNoTitle: {
        "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.\nPhasellus a mi vitae augue rhoncus lobortis ut rutrum metus.\nCurabitur tortor leo, tristique sed mollis quis, condimentum venenatis nibh.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit.\nPhasellus a mi vitae augue rhoncus lobortis ut rutrum metus.\nCurabitur tortor leo, tristique sed mollis quis, condimentum venenatis nibh."
    }

    TextSummary {
        id: textSummary
        anchors.fill: parent
        widgetData: widgetDataComplete
    }

    UT.UnityTestCase {
        name: "TextSummaryTest"
        when: windowShown

        property var textLabel: findChild(textSummary, "textLabel")

        function test_optional_title() {
            var titleLabel = findChild(textSummary, "titleLabel")

            textSummary.widgetData = widgetDataComplete

            compare(titleLabel.visible, true)
            var mappedTextLabel = root.mapFromItem(textLabel, 0, 0)
            compare(mappedTextLabel.y, titleLabel.height)

            textSummary.widgetData = widgetDataNoTitle

            compare(titleLabel.visible, false)
            verify(mappedTextLabel.y, 0)
        }

        function test_see_more() {
            var seeMore = findChild(textSummary, "seeMore")

            textSummary.widgetData = widgetDataComplete

            // when it's more than 7 lines of text, show SeeMore component
            verify(textLabel.lineCount > 7)
            compare(seeMore.visible, true)
            verify(seeMore.more === false)
            verify(textLabel.height < textLabel.contentHeight)

            textSummary.widgetData = widgetDataShortText

            verify(textLabel.lineCount <= 7)
            compare(seeMore.visible, false)
            tryCompare(textLabel, "height", textLabel.contentHeight)
        }
    }
}
