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
    property int filterPriority: 0   // Задел для фильтрации (0 - все, 1-3 - приоритет)

    FontLoader {
        id: robotoRegularFont
        source: "qrc:/resources/fonts/Roboto/Roboto-Regular.ttf"
        onStatusChanged: {
            if (status === FontLoader.Ready) console.log("Шрифт Roboto-Regular загружен: " + name)
        }
    }

    FontLoader {
        id: robotoBoldFont
        source: "qrc:/resources/fonts/Roboto/Roboto-Bold.ttf"
        onStatusChanged: {
            if (status === FontLoader.Ready) console.log("Шрифт Roboto-Bold загружен: " + name)
        }
    }

    FontLoader {
        id: robotoExtraBoldFont
        source: "qrc:/resources/fonts/Roboto/Roboto-ExtraBold.ttf"
        onStatusChanged: {
            if (status === FontLoader.Ready) {
                console.log("Шрифт Roboto-ExtraBold загружен: " + name)
                Styles.Style.setFontFamily(name)
            } else if (status === FontLoader.Error) {
                console.log("Ошибка загрузки шрифта Roboto-ExtraBold")
            }
        }
    }

    FontLoader {
        id: robotoLightFont
        source: "qrc:/resources/fonts/Roboto/Roboto-Light.ttf"
        onStatusChanged: {
            if (status === FontLoader.Ready) console.log("Шрифт Roboto-Light загружен: " + name)
        }
    }

    Component.onCompleted: {
        console.log("Статус FontLoader (ExtraBold): " + robotoExtraBoldFont.status)
        console.log("Имя шрифта Roboto-ExtraBold: " + robotoExtraBoldFont.name)
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
        id: mainColumn
        anchors.fill: parent
        anchors.margins: 10

        Loader {
            id: headerLoader
            width: parent.width
            source: "components/ui/Header.qml"
            onLoaded: {
                item.fontName = robotoExtraBoldFont.status === FontLoader.Ready ? robotoExtraBoldFont.name : "Sans Serif"
            }
        }

        Button {
            id: addTaskButton
            width: parent.width
            height: 50
            text: "Добавить задачу"
            font.family: robotoBoldFont.status === FontLoader.Ready ? robotoBoldFont.name : "Sans Serif"
            font.pixelSize: Styles.Style.fontSizeMedium
            onClicked: {
                console.log("Кнопка 'Добавить задачу' нажата")
                formMode = "add"
                taskFormPopup.mode = formMode
                taskFormPopup.taskName = ""
                taskFormPopup.taskDescription = ""
                taskFormPopup.taskPriority = 1
                taskFormPopup.open()
            }
        }

        ComboBox {
            id: priorityFilter
            width: parent.width
            model: ["Все", "Низкий", "Средний", "Высокий"]
            font.family: robotoRegularFont.status === FontLoader.Ready ? robotoRegularFont.name : "Sans Serif"
            font.pixelSize: Styles.Style.fontSizeMedium
            onCurrentIndexChanged: {
                filterPriority = currentIndex === 0 ? 0 : currentIndex
                console.log("Фильтр приоритета изменён на:", filterPriority)
            }
        }

        ListView {
            width: parent.width
            height: parent.height - headerLoader.height - addTaskButton.height - priorityFilter.height - 30
            model: taskModel
            delegate: TaskItem {
                fontName: robotoRegularFont.status === FontLoader.Ready ? robotoRegularFont.name : "Sans Serif"
                visible: filterPriority === 0 || model.priority === filterPriority // Фильтрация по приоритету
                onClicked: {
                    console.log("Клик по задаче:", taskName, "Индекс:", index)
                    editingTaskIndex = index
                    var task = taskModel.getTask(index)
                    if (task) {
                        formMode = "edit"
                        taskFormPopup.mode = formMode
                        taskFormPopup.taskName = task.name
                        taskFormPopup.taskDescription = task.description
                        taskFormPopup.taskPriority = task.priority
                        taskFormPopup.open()
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

    AddTaskForm {
        id: taskFormPopup
        fontName: robotoRegularFont.status === FontLoader.Ready ? robotoRegularFont.name : "Sans Serif"
        onAddTask: (name, description, priority, category, dueDate) => {
            if (formMode === "add") {
                taskModel.addTaskFromStrings(name, description, priority)
            } else if (formMode === "edit") {
                taskModel.updateTask(editingTaskIndex, name, description, priority)
            }
            taskFormPopup.close()
            editingTaskIndex = -1
            formMode = "add"
        }
        onCancel: {
            taskFormPopup.close()
            editingTaskIndex = -1
            formMode = "add"
        }
    }
}
