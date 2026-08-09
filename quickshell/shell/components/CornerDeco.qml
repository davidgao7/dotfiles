import QtQuick

// NIER corner brackets — cassette futurism style
// Usage: CornerDeco { anchors.fill: parent }

Item {
    anchors.fill: parent
    enabled: false

    property color lineColor: Qt.rgba(200/255, 184/255, 154/255, 0.4)
    property int size: 18
    property real lineWidth: 0.8

    // TL
    Canvas { id: ctl; x: 0; y: 0
        width: size; height: size
        onPaint: drawCorner(getContext("2d"), false, false)
        Component.onCompleted: requestPaint()
        onWidthChanged: requestPaint()
    }
    // TR
    Canvas { id: ctr; x: parent.width - size; y: 0
        width: size; height: size
        onPaint: drawCorner(getContext("2d"), true, false)
        Component.onCompleted: requestPaint()
        onWidthChanged: requestPaint()
    }
    // BL
    Canvas { id: cbl; x: 0; y: parent.height - size
        width: size; height: size
        onPaint: drawCorner(getContext("2d"), false, true)
        Component.onCompleted: requestPaint()
        onWidthChanged: requestPaint()
    }
    // BR
    Canvas { id: cbr; x: parent.width - size; y: parent.height - size
        width: size; height: size
        onPaint: drawCorner(getContext("2d"), true, true)
        Component.onCompleted: requestPaint()
        onWidthChanged: requestPaint()
    }

    onWidthChanged:  { ctl.requestPaint(); ctr.requestPaint(); cbl.requestPaint(); cbr.requestPaint() }
    onHeightChanged: { ctl.requestPaint(); ctr.requestPaint(); cbl.requestPaint(); cbr.requestPaint() }

    function drawCorner(ctx, flipH, flipV) {
        var w = size, h = size
        ctx.clearRect(0, 0, w, h)
        ctx.save()
        if (flipH) { ctx.translate(w, 0); ctx.scale(-1, 1) }
        if (flipV) { ctx.translate(0, h); ctx.scale(1, -1) }

        ctx.strokeStyle = lineColor.toString()
        ctx.fillStyle = lineColor.toString()
        ctx.lineWidth = lineWidth

        var seg = Math.round(w * 0.33)
        var dot = Math.round(w * 0.10)

        ctx.beginPath()
        ctx.moveTo(0, seg)
        ctx.lineTo(seg - dot * 0.5, seg)
        ctx.stroke()

        ctx.beginPath()
        ctx.moveTo(seg, 0)
        ctx.lineTo(seg, seg - dot * 0.5)
        ctx.stroke()

        ctx.fillRect(seg - dot * 0.5, seg - dot * 0.5, dot, dot)
        ctx.restore()
    }
}
