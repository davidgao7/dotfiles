pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

// NotificationCenter — replaces swaync
Singleton {
    id: root

    property var notifications: []

    NotificationServer {
        onTrackedNotificationsChanged: {
            var list = [], all = trackedNotifications
            for (var i = 0; i < Math.min(all.length, 10); i++) {
                var n = all[i]
                list.push({
                    app: n.appName || "",
                    summary: n.summary || "",
                    body: n.body || "",
                    time: new Date()
                })
            }
            root.notifications = list
        }
    }
}
