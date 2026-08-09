import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

// WallpaperPicker — integrated into shell, no external imports
PanelWindow {
    id: root
    color: "#0b0a09"
    width: 480; height: 380
    visible: true
    WlrLayershell.layer: WlrLayer.Top
    exclusionMode: ExclusionMode.Ignore

    property var wallpapers: []
    property string wpDir: ""

    Component.onCompleted: {
        wpDir = Quickshell.env("HOME") + "/anime"
        let cmd = ["sh", "-c", "find " + wpDir + " -maxdepth 2 -type f \\( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \\) 2>/dev/null | sort"]
        let p = Qt.createQmlObject('import Quickshell.Io; Process { running: true; command: ' + JSON.stringify(cmd) + '; stdout: SplitParser { onRead: d => { root.wallpapers.push(d.trim()) } } }', root)
    }

    // Close button
    Rectangle {
        anchors { top: parent.top; right: parent.right; margins: 8 }
        width: 24; height: 24; radius: 12; color: "#c87060"
        Text { anchors.centerIn: parent; text: "X"; color: "white"; font.pixelSize: 12 }
        MouseArea { anchors.fill: parent; onClicked: Qt.quit() }
    }

    // Title
    Text {
        anchors { top: parent.top; horizontalCenter: parent.horizontalCenter; topMargin: 10 }
        text: "WALLPAPER SELECTOR"
        color: "#60a880"; font.family: "Share Tech Mono"; font.pixelSize: 14
    }

    // Wallpaper grid with thumbnails
    GridView {
        id: grid
        anchors { top: parent.top; topMargin: 40; left: parent.left; right: parent.right; bottom: parent.bottom; margins: 8 }
        cellWidth: 140; cellHeight: 100
        model: root.wallpapers
        clip: true

        delegate: Item {
            width: grid.cellWidth - 4; height: grid.cellHeight - 4

            Rectangle {
                anchors.fill: parent; color: "#141210"
                border.color: Qt.rgba(200/255, 184/255, 154/255, 0.15)

                Image {
                    anchors { fill: parent; margins: 1 }
                    source: "file://" + modelData
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true; cache: false
                }

                Rectangle {
                    anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
                    height: 24; color: Qt.rgba(0, 0, 0, 0.7)
                    Text {
                        anchors.centerIn: parent
                        text: modelData.split("/").pop().replace(/\.[^.]+$/, "")
                        color: "#8a7f68"; font.family: "Share Tech Mono"; font.pixelSize: 9
                        elide: Text.ElideRight; width: parent.width - 4
                    }
                }

                MouseArea {
                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                    onClicked: Quickshell.execDetached(["awww", "img", modelData, "--transition-type", "center"])
                }
            }
        }
    }
}
