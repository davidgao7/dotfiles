import Quickshell
import QtQuick
import "components"
import "modules"

// shell.qml — NIER-themed dynamic island
// Island module handles its own PanelWindow; services provide shared state.

ShellRoot {
    id: root

    // ── Services (pre-load singletons) ──────────────────────────
    // MprisService, future: Workspaces, CpuMem, Gpu, Volume, etc.

    // ── Windows: one Island per screen ──────────────────────────
    Variants {
        model: Quickshell.screens

        Island {
            required property var modelData    // injected by Variants
            screen: modelData
        }
    }
}
