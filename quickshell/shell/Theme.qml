pragma Singleton
import QtQuick
import Quickshell

// Theme — NieR:Automata inspired design tokens
// Central place for colors, fonts, and spacing. Reference via Theme.*
Singleton {
    id: root

    // ── Palette (default NieR sepia, updated by ColorSync on wallpaper change) ──
    property color bg: "#0b0a09"
    property color bgRaised: "#141210"
    property color fg: "#c8b89a"
    property color fgDim: "#8a7f68"
    property color accentRed: "#c87060"
    property color accentGreen: "#60a880"
    property color accentBlue: "#6090c8"
    property color accentGold: "#c8a860"

    // ── Fonts ───────────────────────────────────────────────────
    readonly property string fontFamily: "Share Tech Mono"
    readonly property string fontCJK: "Noto Sans CJK SC"

    // ── Typography ──────────────────────────────────────────────
    readonly property int sizeXxs: 10
    readonly property int sizeXs: 12
    readonly property int sizeSm: 14
    readonly property int sizeMd: 16
    readonly property int sizeLg: 20
    readonly property int sizeXl: 28

    // ── Spacing / sizing ────────────────────────────────────────
    readonly property int spacingXs: 2
    readonly property int spacingSm: 4
    readonly property int spacingMd: 8
    readonly property int spacingLg: 16
    readonly property int barHeight: 36

    // ── Effects ─────────────────────────────────────────────────
    readonly property bool rounding: false            // NieR aesthetic: sharp corners
    readonly property real opacityDim: 0.55
    readonly property real opacityHover: 0.85
    readonly property int animationMs: 180            // shared animation duration

    // ── Status helpers ──────────────────────────────────────────
    // map a 0-100 value to green/yellow/red accent (NieR scan aesthetic)
    function statusColor(value) {
        if (value < 50) return root.accentGreen
        if (value < 85) return root.accentGold
        return root.accentRed
    }
}
