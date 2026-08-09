import QtQuick
import "../"
import "../services"

// BboxCat — animated cat mascot, beats faster when media plays
Item {
    id: root
    implicitWidth: 100; implicitHeight: 22

    property var frames: ["(=^･ω･^=)", "₍ᐢ. ̫.ᐢ₎", "(=◕ω◕=)", "(=ΦωΦ=)",
                          "(=✧ω✧=)", "₍ᐢ×  ×ᐢ₎", "(=^∇^=)", "(=♡.♡=)",
                          "₍ᐢᵕ ˕ ᵕᐢ₎", "(=ᵔᵕᵔ=)", "₍˄·͈༝·͈˄₎", "(=^▽^=)"]
    property int _index: 0

    Text {
        anchors.centerIn: parent
        text: root.frames[root._index]
        color: MprisService.playing ? Theme.accentGold : Theme.fgDim
        font.family: Theme.fontFamily
        font.pixelSize: Theme.sizeXs
    }

    Timer {
        id: bboxTimer
        interval: MprisService.playing ? 220 : 600
        repeat: true; running: true
        onTriggered: { root._index = (root._index + 1) % root.frames.length }
    }
}
