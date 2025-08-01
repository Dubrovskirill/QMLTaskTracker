import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "components/ui"
import "components/styles" as Styles

Item {
    id: root

    height: 60



    //todo signal

    ToolBar {
        id: toolBar
        anchors.fill: parent
        background: Rectangle {
            color: window.bgColor
        }

        ToolButton {
            id: btnAddTask
            text: qsTr("+")
            anchors.centerIn: parent
            padding: 0



            //todo onClicked
            width: 40
            height: width



            contentItem: Text {
                text: parent.text
                color: window.bgColor
                padding: 0

                font.pixelSize: 32
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenterOffset: -1.5

            }

            background: Rectangle {
                color: btnAddTask.down ? Qt.darker(window.textColor, 2) : window.textColor
                width: parent.width
                height: parent.height
                radius: 11
            }
        }
    }
}





