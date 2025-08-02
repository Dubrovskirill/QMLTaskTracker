import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15


SwipeDelegate {
    id: root
    property alias name: lblName.text
    property alias descr: lblDescr.text
    property alias priority: priorityIndicator.color
    property alias backgroundColor: rectTask.color
    property alias textColor: lblName.color
    height: parent.height
    width: parent.width
    padding: 0
    swipe.enabled: true

    signal clicked(string taskName)
    signal requestDelete(int row)
    contentItem: Rectangle {
        id: rectTask
        color: tapHandler.pressed ? Qt.darker(window.taskColor, 2) : window.taskColor
        height: parent.height
        width: parent.width
        Rectangle {
            id: priorityIndicator
            width: 5

            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left:parent.left
            anchors.leftMargin: 10

        }


        Text {
            id: lblName

            color: window.textColor
            font.pixelSize: 18
            font.bold:true

            anchors.left:priorityIndicator.right
            anchors.top: parent.top
            anchors.leftMargin: 20
            anchors.topMargin: 10

        }

        Text {
            id:lblDescr

            color: Qt.darker(textColor, 2)
            font.pixelSize: 12
            anchors.left:priorityIndicator.right
            anchors.leftMargin: 20
            anchors.top: lblName.bottom
            anchors.topMargin: 10
        }




    }
    TapHandler {
        id: tapHandler
        onTapped: {
            root.clicked(model.name)
            console.log("Клик по задаче:", model.name, "Индекс:", index)
        }
    }
    swipe.right : Rectangle {
        width: parent.width
        height: parent.height
        color: "red"


        Label {
            text: "Delete"
            color: textColor
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 20
        }
    }
    swipe.transition: Transition {
        NumberAnimation { properties: "x"; duration: 150 }
    }
    swipe.onCompleted: {
            if (swipe.position < 0) { // Свайп вправо
                root.requestDelete(index)
                console.log("Задача удалена при полном свайпе:", model.name)
            }
            root.swipe.close() // Закрываем свайп после завершения
        }

}

