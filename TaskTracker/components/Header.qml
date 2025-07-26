import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: header
    width: parent.width
    height: 60
    color: "lightblue"

    Text {
        anchors.centerIn: parent
        text: "Task Tracker"
        font.pixelSize: 24
        font.bold: true
    }
}
