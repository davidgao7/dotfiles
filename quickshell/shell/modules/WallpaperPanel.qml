import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: root
    anchors { bottom: true; left: true; right: true }
    color: "#0b0a09"
    implicitHeight: 200
    visible: true
    WlrLayershell.layer: WlrLayer.Top
    exclusionMode: ExclusionMode.Ignore

    property var wallpapers: []

    Rectangle {
        anchors { top: parent.top; right: parent.right; margins: 8 }
        width: 24; height: 24; radius: 12; color: "#c87060"
        Text { anchors.centerIn: parent; text: "X"; color: "white"; font.pixelSize: 12 }
        MouseArea { anchors.fill: parent; onClicked: Qt.quit() }
    }

    GridView {
        id: grid
        anchors { fill: parent; margins: 8; topMargin: 32 }
        cellWidth: 100; cellHeight: 72; model: root.wallpapers; clip: true

        delegate: Item {
            width: grid.cellWidth - 2; height: grid.cellHeight - 2
            Rectangle { anchors.fill: parent; color: "#141210"
                Image { anchors.fill: parent; anchors.margins: 1; source: "file://"+modelData; fillMode: Image.PreserveAspectCrop; asynchronous: true }
                MouseArea { anchors.fill: parent
                    onClicked: {
                        Quickshell.execDetached(["awww","img",modelData,"--transition-type","center"])
                        Quickshell.execDetached(["python3",
                            Quickshell.env("HOME") + "/.config/swaync/generate-style.py", modelData])
                    } }
            }
        }
    }

    Process {
        command: ["sh","-c","find "+Quickshell.env("HOME")+"/anime -maxdepth 2 -type f \\( -iname '*.png' -o -iname '*.jpg' -o -iname '*.webp' \\) 2>/dev/null | sort"]
        running: true
        stdout: SplitParser { onRead: d => { var a=root.wallpapers.slice(); a.push(d.trim()); root.wallpapers=a } }
    }
}
