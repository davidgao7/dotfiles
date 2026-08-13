pragma Singleton
import QtQuick
import Quickshell

// NotificationCenter — kept as an empty singleton so Island.qml bindings resolve.
// Notifications are handled by swaync; quickshell must NOT own the
// org.freedesktop.Notifications name or swaync fails to start.
Singleton {
    id: root

    property var notifications: []
}
