import QtQuick
import "../"

// CatMascot — cute typing cat animation for the island
// Cycles through kaomoji and shifts position like typing
Item {
    id: root

    implicitWidth: 80; implicitHeight: 20

    property var frames: ["(=^･ω･^=)", "(=^･^=)", "(=◕‿◕=)", "(=ΦωΦ=)",
                          "(=ＴェＴ=)", "(=｀ω´=)", "(=^▽^=)", "(=♡.♡=)"]
    property int _index: 0

    Text {
        anchors.centerIn: parent
        text: root.frames[root._index]
        color: Theme.accentGold
        font.family: Theme.fontFamily
        font.pixelSize: Theme.sizeXs
    }

    Timer {
        interval: 400; repeat: true; running: true
        onTriggered: { root._index = (root._index + 1) % root.frames.length }
    }
}
