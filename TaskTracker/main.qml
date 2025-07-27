import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import "components/ui"
import "components/styles" as Styles

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

    property bool showTaskForm: false
    property int editingTaskIndex: -1
    property string formMode: "add"  // "add" или "edit"


    Text {
        anchors.bottom: parent.bottom
        text: "Тест шрифта Font Test"
        font.family: robotoFont.status === FontLoader.Ready ? robotoFont.name : "Sans Serif"
        font.pixelSize: 30
    }


    FontLoader {
            id: robotoFont
            source: "qrc:/resources/fonts/Roboto/Roboto-ExtraBold.ttf"
            onStatusChanged: {
                if (status === FontLoader.Ready) {
                    console.log("Шрифт Roboto загружен: " + name)
                    Styles.Style.setFontFamily(name)  // ✅ через синглтон
                } else if (status === FontLoader.Error) {
                    console.log("Ошибка загрузки шрифта Roboto")
                }
            }
        }


    Component.onCompleted: {
        console.log("Статус FontLoader: " + robotoFont.status)
        console.log("Имя шрифта: " + robotoFont.name)
        console.log("Имя шрифта Roboto: " + robotoFont.name)
        console.log("Styles.Style тип:", typeof Styles.Style)
        console.log("Styles.Style — это QtObject?", Styles.Style instanceof QtObject)


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

    Column {
        anchors.fill: parent
        anchors.margins: 10

        Header {
            width: parent.width
            fontName: robotoFont.status === FontLoader.Ready ? robotoFont.name : "Sans Serif"
        }

        Button {
            width: parent.width
            height: 50
            text: "Добавить задачу"
            onClicked: {
                formMode = "add"
                taskForm.taskName = ""
                taskForm.taskDescription = ""
                taskForm.taskPriority = 1
                showTaskForm = true
            }
        }

        AddTaskForm {
            id: taskForm
            width: parent.width
            visible: showTaskForm
            mode: formMode

            onAddTask: {
                if (mode === "add") {
                    taskModel.addTaskFromStrings(name, description, priority)
                } else if (mode === "edit") {
                    taskModel.updateTask(editingTaskIndex, name, description, priority)
                }
                showTaskForm = false
                editingTaskIndex = -1
                formMode = "add"
            }

            onCancel: {
                showTaskForm = false
                editingTaskIndex = -1
                formMode = "add"
            }
        }

        ListView {
            width: parent.width
            height: parent.height - 120
            model: taskModel

            delegate: TaskItem {
                onClicked: {
                    console.log("Клик по задаче:", taskName, "Индекс:", index)
                    editingTaskIndex = index
                    var task = taskModel.getTask(index)
                    if (task) {
                        formMode = "edit"
                        taskForm.taskName = task.name
                        taskForm.taskDescription = task.description
                        taskForm.taskPriority = task.priority
                        showTaskForm = true
                    } else {
                        console.warn("Задача не найдена по индексу:", index)
                    }
                }
                onRequestDelete: {
                    taskModel.removeTask(index)
                }
            }
        }
    }
}
