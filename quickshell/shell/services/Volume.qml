pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Volume — audio volume via wpctl (Pipewire)
Singleton {
    id: root

    property int volume: 0
    property bool muted: false

    Process {
        id: volProc
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{print $2*100}'"]
        stdout: SplitParser {
            onRead: data => {
                var v = Math.round(parseFloat(data.trim()))
                if (!isNaN(v)) root.volume = Math.min(100, Math.max(0, v))
            }
        }
    }
    Timer { interval: 2000; repeat: true; running: true
        onTriggered: { volProc.running = true } }
}
