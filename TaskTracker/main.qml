import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: window
    width: 480
    height: 854
    minimumWidth: 400
    minimumHeight: 711
    maximumWidth: 640
    maximumHeight: 1138
    visible: true
    title: "Task Tracker"

    Component.onCompleted: {
        console.log("ApplicationWindow completed")
        console.log("Platform:", Qt.platform.os)
        console.log("Window size:", width, "x", height)

        if (Qt.platform.os !== "android" && Qt.platform.os !== "ios") {
            window.visibility = Window.Windowed
            window.minimumWidth = window.width
            window.maximumWidth = window.width
            window.minimumHeight = window.height
            window.maximumHeight = window.height
            console.log("Desktop mode: Windowed, fixed size")
        } else {
            console.log("Mobile mode")
        }
    }

    // Главный контейнер
    Column {
        anchors.fill: parent
        anchors.margins: 10

        // Заголовок
        Rectangle {
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

        // Кнопка добавления тестовых задач
        Button {
            width: parent.width
            height: 50
            text: "Добавить тестовые задачи"

        }

        // Список задач
        ListView {
            width: parent.width
            height: parent.height - 120 // вычитаем заголовок и кнопку
            model: taskModel

            delegate: Rectangle {
                width: parent.width
                height: 80
                color: index % 2 === 0 ? "lightgray" : "white"
                border.color: "gray"
                border.width: 1

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
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("Клик по задаче:", model.name)
                    }
                }
            }
        }
    }
}

