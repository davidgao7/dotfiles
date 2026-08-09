import Quickshell
import QtQuick
import "components"

// shell.qml — NIER-themed entry point
// Services: state backends / Components: reusable UI / Modules: features

ShellRoot {
    id: root

    // ── Windows (per-screen) ────────────────────────────────────
    Variants {
        model: Quickshell.screens

        Scope {
            required property var modelData

            PanelWindow {
                screen: modelData

                visible: Settings.barEnabled
                anchors { top: true; left: true; right: true }
                exclusiveZone: Theme.barHeight
                color: Theme.bg

                // ── Corner brackets ─────────────────────────────
                CornerDeco {
                    anchors.fill: parent
                    size: Theme.barHeight
                    lineColor: Qt.rgba(0.78, 0.72, 0.60, 0.55)  // more visible sepia
                }

                // ── Bar contents ────────────────────────────────
                Row {
                    anchors.centerIn: parent
                    spacing: Theme.spacingMd

                    Text {
                        text: "SHELL // BOOTSTRAP // NIER"
                        color: Theme.accentGreen
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.sizeXs
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                // ── Scanlines + grain overlay (on top) ──────────
                Scanlines {
                    anchors.fill: parent
                    lineOpacity: 0.12             // dialed up for visibility
                }
            }
        }
    }
}
