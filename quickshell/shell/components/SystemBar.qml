import QtQuick
import "../"

// SystemBar — compact resource gauge (caelestia-inspired)
// Usage: SystemBar { label: "CPU"; value: 45 }
Item {
    id: root

    property string label: ""
    property int value: 0

    implicitWidth: 80; implicitHeight: 24

    Column {
        anchors.fill: parent
        spacing: 2

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.label
            color: Theme.fgDim
            font.family: Theme.fontFamily
            font.pixelSize: Theme.sizeXxs
        }

        // Bar background
        Rectangle {
            width: parent.width; height: 6
            radius: 3
            color: Qt.rgba(200/255, 184/255, 154/255, 0.1)

            // Bar fill
            Rectangle {
                height: parent.height; radius: 3
                width: Math.min(1, root.value / 100) * parent.width
                color: Theme.statusColor(root.value)
                Behavior on width { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.value + "%"
            color: Theme.statusColor(root.value)
            font.family: Theme.fontFamily
            font.pixelSize: Theme.sizeXxs
        }
    }
}
