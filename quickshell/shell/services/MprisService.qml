pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// MprisService — media player state via playerctl
// Binds: MprisService.title / artist / album / playing / hasPlayer
Singleton {
    id: root

    property string status: ""
    property string artist: ""
    property string title: ""
    property string album: ""
    property bool playing: status === "Playing"
    property bool hasPlayer: status !== ""

    Process {
        command: ["playerctl", "-F", "metadata",
                  "--format", "{{status}}|{{artist}}|{{title}}|{{album}}"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                var parts = data.trim().split("|")
                if (parts.length >= 1) root.status  = parts[0]
                if (parts.length >= 2) root.artist  = parts[1]
                if (parts.length >= 3) root.title   = parts[2]
                if (parts.length >= 4) root.album   = parts[3]
            }
        }
    }
}
