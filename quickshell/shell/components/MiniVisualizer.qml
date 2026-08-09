import QtQuick
import "../"
import "../services"

// MiniVisualizer — animated equalizer bars for the island
Item {
    id: root
    width: 100; height: 24

    property bool active: MprisService.playing
    property var _levels: [0.3,0.6,0.9,0.4,0.7,0.5,0.8,0.2,0.6,0.4]

    Row {
        anchors.centerIn: parent
        spacing: 2
        Repeater {
            model: 10
            Rectangle {
                width: 5; radius: 2
                height: root._levels[index] * root.height
                y: root.height - height
                color: Theme.accentGreen
                opacity: root.active ? 0.8 : 0.25
                Behavior on height { NumberAnimation { duration: 150; easing.type: Easing.OutElastic } }
            }
        }
    }

    Timer {
        interval: 150; repeat: true; running: root.active
        onTriggered: {
            var arr = []
            for (var i = 0; i < 10; i++) arr.push(Math.random() * 0.3 + 0.15)
            arr.sort()
            root._levels = arr
        }
    }
}
