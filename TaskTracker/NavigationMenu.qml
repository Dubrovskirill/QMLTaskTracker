import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components/ui"
import "components/styles" as Styles

Rectangle {
    id: root
    color: window.bgColor
    height: 60



    //todo signal

    ToolBar {
        id: toolBar
        anchors.fill: parent
        background: Rectangle {
            color: window.bgColor
        }

        ToolButton {
            id:btnAddTask
            text: qsTr("+")
            anchors.centerIn: parent
            //todo onClicked
        }
    }
}
