import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "../"
import "../components"
import "../services"

PanelWindow {
    id: root
    anchors { top: true; left: true; right: true }
    implicitHeight: pill.height
    margins { top: 0 }
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    exclusiveZone: 0
    WlrLayershell.layer: WlrLayer.Top
    mask: Region { item: pill }

    property bool _pinned: false
    property bool _hovering: false
    property bool expanded: _pinned || _hovering
    property bool _showingWP: false
    property var currentTime: new Date()

    Connections {
        target: MprisService
        function onPlayingChanged() {
            if (!MprisService.playing) root._pinned = false
        }
    }

    Timer {
        interval: 1000; repeat: true; running: true
        onTriggered: root.currentTime = new Date()
    }

    Process {
        id: wpProc
        command: ["quickshell", "-p", Quickshell.shellPath("modules/WallpaperPanel.qml")]
        running: false
    }

    readonly property int collapsedWidth: Settings.s(220)
    readonly property int collapsedHeight: Theme.barHeight
    readonly property int expandedHeight: Settings.s(320)
    readonly property int contentPadding: Theme.spacingLg * 3

    Rectangle {
        id: pill
        x: (root.width - pill.width) / 2; y: 0
        width: root.expanded
            ? Math.min(Settings.s(640), Math.max(root.collapsedWidth, expandedRow.implicitWidth + root.contentPadding))
            : root.collapsedWidth
        height: root.expanded ? root.expandedHeight : root.collapsedHeight
        radius: height / 2
        color: Theme.bg
        border.color: Qt.rgba(200/255, 184/255, 154/255, 0.15)
        border.width: 0.5
        clip: true

        Behavior on width  { NumberAnimation { duration: 380; easing.type: Easing.InOutCubic } }
        Behavior on height { NumberAnimation { duration: 380; easing.type: Easing.InOutCubic } }

        // Bottom-layer hover/click zone (behind all content, so inner buttons work)
        MouseArea {
            anchors.fill: parent; z: -1
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onEntered: root._hovering = true
            onExited: { root._hovering = false; if (!MprisService.playing) root._pinned = false }
            onClicked: root._pinned = !root._pinned
        }

        CornerDeco { anchors.fill: parent; size: 14; lineColor: Qt.rgba(0.78, 0.72, 0.60, 0.45) }
        Scanlines { anchors.fill: parent; lineOpacity: 0.08 }

        // Collapsed
        Item {
            id: collapsedContent
            anchors.centerIn: parent
            opacity: root.expanded ? 0 : 1
            Behavior on opacity { NumberAnimation { duration: 200 } }
            Row {
                anchors.centerIn: parent; spacing: Theme.spacingMd
                Item {
                    id: marqueeContainer
                    width: MprisService.playing ? collapsedWidth - Theme.spacingLg * 3 : 0
                    height: Theme.sizeXs + 4
                    visible: MprisService.hasPlayer && MprisService.playing
                    clip: true
                    property int marqueeOffset: 0
                    Text {
                        id: mediaMarquee
                        text: "▷▷  " + MprisService.artist + " – " + MprisService.title
                        color: Theme.accentGreen; font.family: Theme.fontFamily; font.pixelSize: Theme.sizeXs
                        verticalAlignment: Text.AlignVCenter; x: marqueeContainer.marqueeOffset
                    }
                    Timer {
                        interval: 50; repeat: true; running: MprisService.playing
                        onTriggered: {
                            var n = marqueeContainer.marqueeOffset - 1
                            if (n <= -(mediaMarquee.implicitWidth + 40)) n = marqueeContainer.width
                            marqueeContainer.marqueeOffset = n
                        }
                    }
                }
                Text {
                    text: Qt.formatTime(root.currentTime, "HH:mm"); color: Theme.fg
                    font.family: Theme.fontFamily; font.pixelSize: Theme.sizeSm
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    text: NotificationCenter.notifications.length > 0 ? "🔔" + NotificationCenter.notifications.length : ""
                    color: Theme.accentGold; font.pixelSize: Theme.sizeXxs
                    visible: NotificationCenter.notifications.length > 0
                }
            }
        }

        // Expanded
        Item {
            id: expandedContent
            anchors.centerIn: parent
            opacity: root.expanded ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 240 } }
            Row {
                id: expandedRow
                anchors.centerIn: parent; spacing: Theme.spacingLg

                Column {
                    anchors.verticalCenter: parent.verticalCenter; spacing: 0
                    Text { text: Qt.formatTime(root.currentTime, "HH"); color: Theme.fg; font.family: Theme.fontFamily; font.pixelSize: Theme.sizeXl }
                    Text { text: "::"; color: Theme.fgDim; font.family: Theme.fontFamily; font.pixelSize: Theme.sizeSm; anchors.horizontalCenter: parent.horizontalCenter }
                    Text { text: Qt.formatTime(root.currentTime, "mm"); color: Theme.fg; font.family: Theme.fontFamily; font.pixelSize: Theme.sizeXl }
                }
                Rectangle { width: 1; height: parent.height; color: Qt.rgba(200/255,184/255,154/255,0.15) }

                Row {
                    anchors.verticalCenter: parent.verticalCenter; spacing: Theme.spacingXs
                    Repeater {
                        model: Workspaces.list
                        Text {
                            text: modelData === Workspaces.activeId ? "●" : "○"
                            color: modelData === Workspaces.activeId ? Theme.accentGreen : Theme.fgDim
                            font.family: Theme.fontFamily; font.pixelSize: Theme.sizeXxs
                        }
                    }
                }
                Rectangle { width: 1; height: parent.height; color: Qt.rgba(200/255,184/255,154/255,0.15) }

                Column {
                    anchors.verticalCenter: parent.verticalCenter; spacing: Theme.spacingSm

                    Item {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: Settings.s(360); height: Theme.sizeSm + 4; clip: true
                        property int scrollOffset: 0
                        property string displayText: MprisService.hasPlayer && MprisService.playing
                            ? MprisService.artist + " – " + MprisService.title : "NO MEDIA // STANDBY"
                        Text {
                            id: expandedMediaText; text: parent.displayText
                            color: Theme.accentGreen; font.family: Theme.fontFamily; font.pixelSize: Theme.sizeSm
                            verticalAlignment: Text.AlignVCenter; x: parent.scrollOffset
                        }
                        Timer {
                            interval: 50; repeat: true; running: parent.displayText.length > 25
                            onTriggered: {
                                var n = parent.scrollOffset - 1
                                if (n <= -(expandedMediaText.implicitWidth + 40)) n = parent.width
                                parent.scrollOffset = n
                            }
                        }
                    }

                    CuteCat { anchors.horizontalCenter: parent.horizontalCenter }
                    MiniVisualizer { anchors.horizontalCenter: parent.horizontalCenter }
                    Item { height: Theme.spacingMd; width: 1 }

                    Column {
                        anchors.horizontalCenter: parent.horizontalCenter
                        visible: NotificationCenter.notifications.length > 0
                        Repeater {
                            model: Math.min(3, NotificationCenter.notifications.length)
                            Text {
                                text: "· " + (NotificationCenter.notifications[index]?.summary || "")
                                color: Theme.fgDim; font.family: Theme.fontFamily; font.pixelSize: Theme.sizeXxs
                                elide: Text.ElideRight; width: Settings.s(360)
                            }
                        }
                    }

                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 40; height: 18; radius: 9
                        color: MprisService.playing ? Theme.accentGreen : Theme.fgDim

                        Text {
                            anchors.centerIn: parent
                            text: root._showingWP ? "ON" : "WP"
                            color: Theme.bg; font.family: Theme.fontFamily; font.pixelSize: Theme.sizeXxs
                        }

                        MouseArea {
                            anchors.fill: parent
                        onClicked: { wpProc.running = !wpProc.running }
                        }
                    }

                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter; spacing: Theme.spacingMd
                        SystemBar { label: "CPU"; value: SystemInfo.cpuUsage }
                        SystemBar { label: "GPU"; value: SystemInfo.gpuUsage }
                        SystemBar { label: "MEM"; value: SystemInfo.memUsage }
                        SystemBar { label: "VOL"; value: Volume.volume }
                    }
                }
            }
        }
    }
}
