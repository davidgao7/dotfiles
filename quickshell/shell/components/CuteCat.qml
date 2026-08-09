import QtQuick
import Quickshell
import "../"
import "../services"

// CuteCat — animated cat GIF (bongocat / kurukuru)
Item {
    id: root
    implicitWidth: 80; implicitHeight: 80

    readonly property string src: Quickshell.shellPath("assets/bongocat.gif")

    AnimatedImage {
        anchors.centerIn: parent
        source: root.src
        width: root.implicitWidth; height: root.implicitHeight
        playing: MprisService.playing
        paused: !MprisService.playing
        fillMode: Image.PreserveAspectFit
        cache: false
    }
}
