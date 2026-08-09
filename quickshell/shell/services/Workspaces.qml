pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Workspaces — Hyprland workspace state (polled via hyprctl)
Singleton {
    id: root

    property int activeId: 1
    readonly property var list: {
        var arr = []
        for (var i = 1; i <= 10; i++) arr.push(i)
        return arr
    }

    Process {
        id: wsProc
        command: ["sh", "-c", "hyprctl activeworkspace -j 2>/dev/null | grep '\"id\"' | awk '{print $2}' | tr -d ','"]
        stdout: SplitParser {
            onRead: data => {
                var v = parseInt(data.trim())
                if (!isNaN(v) && v > 0) root.activeId = v
            }
        }
    }

    Timer { interval: 500; repeat: true; running: true
        onTriggered: { wsProc.running = true } }
}
