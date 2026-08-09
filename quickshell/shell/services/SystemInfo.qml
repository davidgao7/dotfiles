pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// SystemInfo — CPU / GPU / Memory stats, polled on interval
Singleton {
    id: root

    property int cpuUsage: 0
    property int gpuUsage: 0
    property int memUsage: 0

    // ── CPU (read /proc/stat every 2s) ─────────────────────────
    property var _prevIdle: 0
    property var _prevTotal: 0

    Process {
        id: cpuProc
        command: ["sh", "-c", "awk '/^cpu /{print $2+$3+$4+$5\" \"$4+$5}' /proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                var parts = data.trim().split(" ")
                var total = parseInt(parts[0]) || 0
                var idle  = parseInt(parts[1]) || 0
                if (root._prevTotal > 0) {
                    var diffTotal = total - root._prevTotal
                    var diffIdle  = idle - root._prevIdle
                    root.cpuUsage = Math.round(100 - diffIdle / diffTotal * 100)
                }
                root._prevTotal = total
                root._prevIdle  = idle
            }
        }
    }
    Timer { interval: 2000; repeat: true; running: true
        onTriggered: cpuProc.running = true }

    // ── Memory (read /proc/meminfo every 3s) ───────────────────
    Process {
        id: memProc
        command: ["sh", "-c", "awk '/^MemTotal:/{t=$2}/^MemAvailable:/{a=$2}END{printf \"%d\",(1-a/t)*100}' /proc/meminfo"]
        stdout: SplitParser {
            onRead: data => {
                root.memUsage = Math.round(parseFloat(data.trim())) || 0
            }
        }
    }
    Timer { interval: 3000; repeat: true; running: true
        onTriggered: memProc.running = true }

    // ── GPU (reuse existing gpu_status.sh) ─────────────────────
    Process {
        id: gpuProc
        command: ["bash", Quickshell.env("HOME") + "/dotfiles/waybar/gpu_status.sh"]
        stdout: SplitParser {
            onRead: data => {
                try {
                    var json = JSON.parse(data.trim())
                    root.gpuUsage = parseInt(json.text) || 0
                } catch (e) {}
            }
        }
    }
    Timer { interval: 2000; repeat: true; running: true
        onTriggered: gpuProc.running = true }
}
