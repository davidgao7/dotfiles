pragma Singleton
import QtQuick
import Quickshell

// Settings — user-adjustable configuration for the shell
// Persistent overrides go here; sensitive/local state belongs in Quickshell.dataPath()
Singleton {
    id: root

    // Global UI scale multiplier (1.0 = 100%)
    readonly property real scale: 1

    // ── Responsive units (equivalent to CSS vw/vh) ──────────────
    readonly property real screenW: Quickshell.screens.length > 0
                                    ? Quickshell.screens[0].width : 1920
    readonly property real screenH: Quickshell.screens.length > 0
                                    ? Quickshell.screens[0].height : 1080

    // Settings.vw(5) = 5% of screen width
    function vw(pct) { return Math.round(root.screenW * pct / 100) }
    function vh(pct) { return Math.round(root.screenH * pct / 100) }

    // Scaled size: Settings.s(320) = 320 * scale
    function s(base) { return Math.round(base * root.scale) }

    // ── Component toggles ───────────────────────────────────────
    readonly property bool barEnabled: true
    readonly property bool notificationsEnabled: true
    readonly property bool powerMenuEnabled: true

    // ── Media ───────────────────────────────────────────────────
    readonly property string mprisPlayer: "spotify"   // primary player

    // ── Commands ────────────────────────────────────────────────
    readonly property string lockCommand: "hyprlock"
}
