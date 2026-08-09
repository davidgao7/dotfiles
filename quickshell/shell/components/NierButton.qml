import QtQuick
import "../"

// NIER button — fill-slide hover + click flash
// Usage: NierButton { label: "PLAY"; onClicked: doSomething() }

Item {
    id: root

    property string label: ""
    property color fgColor: Qt.rgba(200/255, 184/255, 154/255, 0.5)
    property color fgHover: Qt.rgba(11/255, 10/255, 9/255, 1.0)
    property color fillColor: Qt.rgba(200/255, 184/255, 154/255, 1.0)
    property color borderColor: Qt.rgba(200/255, 184/255, 154/255, 0.18)
    property int fontSize: 8
    property real letterSpacing: 1.5
    property int padH: 12
    property int padV: 5

    signal clicked

    implicitWidth: labelText.implicitWidth + padH * 2
    implicitHeight: labelText.implicitHeight + padV * 2

    // Border
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: root.borderColor
        border.width: 1
    }

    // Fill slide (left to right)
    Rectangle {
        id: fillRect
        anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
        width: 0
        color: root.fillColor
        Behavior on width {
            NumberAnimation { duration: 220; easing.type: Easing.InOutQuart }
        }
    }

    // Click flash
    Rectangle {
        id: clickFlash
        anchors.fill: parent
        color: Qt.rgba(1, 1, 1, 0)
        opacity: 0
        NumberAnimation {
            id: flashAnim
            target: clickFlash; property: "opacity"
            from: 0.18; to: 0; duration: 280
            easing.type: Easing.OutQuad
        }
    }

    // Label
    Text {
        id: labelText
        anchors.centerIn: parent
        text: root.label
        font.family: Theme.fontFamily
        font.pixelSize: root.fontSize
        font.letterSpacing: root.letterSpacing
        color: ma.containsMouse ? root.fgHover : root.fgColor
        Behavior on color { ColorAnimation { duration: 150 } }
        z: 1
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        onEntered: fillRect.width = root.width
        onExited: fillRect.width = 0
        onClicked: { flashAnim.start(); root.clicked() }
    }
}
