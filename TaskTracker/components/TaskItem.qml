import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: taskItem
    width: parent.width
    height: 80
    color: index % 2 === 0 ? "lightgray" : "white"
    border.color: "gray"
    border.width: 1

    // Сигнал для клика
    signal clicked(string taskName)

    Column {
        anchors.fill: parent
        anchors.margins: 10

        Text {
            text: model.name
            font.pixelSize: 16
            font.bold: true
        }

        Text {
            text: model.description
            font.pixelSize: 12
            color: "gray"
        }

        Text {
            text: "Приоритет: " + model.priority
            font.pixelSize: 10
            color: "blue"
        }

        Button {
            text: "Удалить"
            anchors.right: parent.right
            anchors.bottom: parent.botton
            onClicked: {
                taskItem.requestDelete(index)
            }
        }
    }
    signal requestDelete(int row)
    MouseArea {
        anchors.fill: parent
        onClicked: {
            taskItem.clicked(model.name)
            console.log("Клик по задаче:", model.name)
        }
    }
}
