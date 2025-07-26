import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import "components"

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

    property bool showAddForm: false

    // Главный контейнер
    Column {
        anchors.fill: parent
        anchors.margins: 10


        Header {
            width: parent.width
        }


        Button {
            width: parent.width
            height: 50
            text: "Добавить задачу"
            onClicked: showAddForm = true

        }

        AddTaskForm {
            width: parent.width
            visible: showAddForm
            z:10
            onAddTask: {
                // Добавляем задачу через TaskModel
                taskModel.addTaskFromStrings(name, description, priority)
                showAddForm = false
            }
            onCancel: showAddForm = false
        }

        ListView {
            width: parent.width
            height: parent.height - 120 // вычитаем заголовок и кнопку
            model: taskModel

            delegate: TaskItem {
                // Подключаем сигнал clicked
                onClicked: function(taskName) {
                    console.log("Клик по задаче из main.qml:", taskName)
                    // Здесь можно добавить логику для редактирования задачи
                }
                onRequestDelete: {
                           taskModel.removeTask(row)
                       }
            }
        }
    }
}

