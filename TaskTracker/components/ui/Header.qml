import QtQuick 2.15
import QtQuick.Controls 2.15
import "../styles" as Styles

Rectangle {
    id: header
    width: parent.width
    height: 60
    color: Styles.Style.backgroundColor

    property string fontName: "Sans Serif"

    Text {

        anchors.centerIn: parent
        text: qsTr("Task Tracker")
        font.pixelSize: Styles.Style.fontSizeLarge
        font.family: fontName
        color: Styles.Style.textPrimary
    }

    Component.onCompleted: {
        console.log("fontFamily в Header: " + Styles.Style.fontFamily)
        console.log("Header: fontName изменился на", fontName)
    }
}
