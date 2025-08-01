import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components/ui"
import "components/styles" as Styles

Item {
    id: root
    property alias name: lblName.text
    property alias descr: lblDescr.text
    property alias priority: priorityIndicator.color
    property alias backgroundColor: rectTask.color
    property alias textColor: lblName.color


    signal clicked(string taskName)
    Rectangle {
        id: rectTask
        color: mouseArea.containsPress ? Qt.darker(window.taskColor, 2) : window.taskColor
        anchors.fill: parent
        Rectangle {
            id: priorityIndicator
            width: 5
           // color: model.priority === 3 ? "red" : (model.priority === 1 ? "green" : "orange")
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left:parent.left
            anchors.leftMargin: 10

        }


        Text {
            id: lblName
            //text:  model.name
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
            //text: model.description
            color: Qt.darker(textColor, 2)
            font.pixelSize: 12
            anchors.left:priorityIndicator.right
            anchors.leftMargin: 20
            anchors.top: lblName.bottom
            anchors.topMargin: 10
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: {
                root.clicked(model.name)
                console.log("Клик по задаче:", model.name, "Индекс:", index)
            }
        }


    }
}
