import QtQuick

// NIER CRT scanlines + film grain overlay
// Usage: Scanlines { anchors.fill: parent }

Item {
    anchors.fill: parent
    property real lineOpacity: 0.06
    property int lineSpacing: 3
    property bool grain: true
    enabled: false               // pass events through

    // Scanlines via Canvas (lighter than Repeater of Rectangles)
    Canvas {
        id: cv
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            ctx.fillStyle = "rgba(0,0,0," + lineOpacity + ")"
            for (var y = 0; y < height; y += lineSpacing + 1)
                ctx.fillRect(0, y, width, 1)
        }
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        Component.onCompleted: requestPaint()
    }

    // Film grain (random sepia dots)
    Canvas {
        anchors.fill: parent
        visible: grain
        opacity: 0.35
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            var density = Math.floor(width * height / 8)
            for (var i = 0; i < density; i++) {
                var x = Math.floor(Math.random() * width)
                var y = Math.floor(Math.random() * height)
                var a = Math.random() * 0.12
                ctx.fillStyle = "rgba(200,184,154," + a + ")"
                ctx.fillRect(x, y, 1, 1)
            }
        }
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        Component.onCompleted: requestPaint()
    }
}
