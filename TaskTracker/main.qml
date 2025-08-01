import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
//import "components/ui"
//import "components/styles" as Styles

ApplicationWindow {
    id: window
    width: 480
    height: 854
    visible: true

    title: "Task Tracker"
    minimumWidth: 400
    minimumHeight: 711
    maximumWidth: 640
    maximumHeight: 1138

    readonly property int  defMargin: 10


    readonly property color bgColor: "#000000"
    readonly property color textColor: "#fefefe"
    readonly property color taskColor: "#19191b"

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
    StackView {
        id:stackView
        anchors.fill: parent
        initialItem: mainPage
    }
    function popPage() {
        stackView.pop();
    }

    Page {
        id: mainPage
        //anchors.fill: parent
        background: Rectangle {
            color: window.bgColor
        }

        header: Rectangle{
            height: 100
            color: "lightgrey"
        }

        ListView {
            id: listView
            anchors.fill: parent
            spacing: defMargin
            anchors.topMargin: defMargin
            anchors.bottomMargin: defMargin
            ScrollBar.vertical: ScrollBar {}
            model: taskModel
            delegate: TaskItem {
                height: 80
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: defMargin
                anchors.bottomMargin: defMargin

                name: model.name
                descr: model.description
                priority: model.priority === 3 ? "red" : (model.priority === 1 ? "green" : "orange")
            }
        }


        footer: NavigationMenu {
            onNewTask: {
                console.log("Полученно")
                stackView.push(addTaskPageComponent)

            }
        }
    }

    Component {
        id: addTaskPageComponent
        AddTaskPage {
            id: addTaskPage
            Connections {
                target: addTaskPage
                function onAddTask(name, description, priority) {
                    taskModel.addTaskFromStrings(name, description, priority)
                }
            }
        }
    }


}

//    property bool showTaskForm: false
//    property int editingTaskIndex: -1
//    property string formMode: "add"  // "add" или "edit"
//    property int filterPriority: 0   // Задел для фильтрации (0 - все, 1-3 - приоритет)
//    property int currentScreen: 0 // 0 - задачи, 1 - покупки, 2 - настройки

//    FontLoader {
//        id: robotoRegularFont
//        source: "qrc:/resources/fonts/Roboto/Roboto-Regular.ttf"
//        onStatusChanged: {
//            if (status === FontLoader.Ready) console.log("Шрифт Roboto-Regular загружен: " + name)
//        }
//    }

//    FontLoader {
//        id: robotoBoldFont
//        source: "qrc:/resources/fonts/Roboto/Roboto-Bold.ttf"
//        onStatusChanged: {
//            if (status === FontLoader.Ready) console.log("Шрифт Roboto-Bold загружен: " + name)
//        }
//    }

//    FontLoader {
//        id: robotoExtraBoldFont
//        source: "qrc:/resources/fonts/Roboto/Roboto-ExtraBold.ttf"
//        onStatusChanged: {
//            if (status === FontLoader.Ready) {
//                console.log("Шрифт Roboto-ExtraBold загружен: " + name)
//                Styles.Style.setFontFamily(name)
//            } else if (status === FontLoader.Error) {
//                console.log("Ошибка загрузки шрифта Roboto-ExtraBold")
//            }
//        }
//    }

//    FontLoader {
//        id: robotoLightFont
//        source: "qrc:/resources/fonts/Roboto/Roboto-Light.ttf"
//        onStatusChanged: {
//            if (status === FontLoader.Ready) console.log("Шрифт Roboto-Light загружен: " + name)
//        }
//    }

//    Component.onCompleted: {
//        console.log("Статус FontLoader (ExtraBold): " + robotoExtraBoldFont.status)
//        console.log("Имя шрифта Roboto-ExtraBold: " + robotoExtraBoldFont.name)
//        console.log("Styles.Style тип:", typeof Styles.Style)
//        console.log("Styles.Style — это QtObject?", Styles.Style instanceof QtObject)
//        console.log("ApplicationWindow completed")
//        console.log("Platform:", Qt.platform.os)
//        console.log("Window size:", width, "x", height)

//        if (Qt.platform.os !== "android" && Qt.platform.os !== "ios") {
//            window.visibility = Window.Windowed
//            window.minimumWidth = window.width
//            window.maximumWidth = window.width
//            window.minimumHeight = window.height
//            window.maximumHeight = window.height
//            console.log("Desktop mode: Windowed, fixed size")
//        } else {
//            console.log("Mobile mode")
//        }
//    }

//    StackLayout {
//        id: mainStack
//        anchors.fill: parent
//        currentIndex: currentScreen

////        // Экран задач
////        TaskPanel {
////            // твой экран задач (ListView, фильтры и т.д.)
////        }

////        // Экран списка покупок
////        ShoppingList {
////            // пока просто заглушка "Скоро"
////        }

////        // Экран настроек
////        Settings {
////            // поле для имени пользователя и т.д.
////        }
//    }

//    // Нижняя навигация
//    RowLayout {
//        id: bottomNav
//        anchors.left: parent.left
//        anchors.right: parent.right
//        anchors.bottom: parent.bottom
//        height: 64
//        spacing: 0
//        Rectangle {
//            Layout.fillWidth: true
//            color: "transparent"
//            Button {
//                anchors.centerIn: parent
//                text: "Задачи"
//                onClicked: currentScreen = 0
//                background: Rectangle {
//                    color: currentScreen === 0 ? "#007AFF" : "transparent"
//                    radius: 8
//                }
//            }
//        }

//        Rectangle {
//            width: 64
//            height: 64
//            color: "transparent"
//            // FAB-кнопка
//            Rectangle {
//                id: fab
//                width: 56
//                height: 56
//                radius: 28
//                color: "#007AFF"
//                anchors.centerIn: parent
//                scale: fabMouse.pressed ? 0.9 : 1.0
//                Behavior on scale { NumberAnimation { duration: 100 } }
//                Text {
//                    anchors.centerIn: parent
//                    text: "+"
//                    color: "white"
//                    font.pixelSize: 36
//                    font.bold: true
//                }
//                MouseArea {
//                    id: fabMouse
//                    anchors.fill: parent
//                    onClicked: {
//                        // Открыть AddTaskForm
//                        showTaskForm = true
//                    }
//                }
//            }
//        }
//        Rectangle {
//            Layout.fillWidth: true
//            color: "transparent"
//            Button {
//                anchors.centerIn: parent
//                text: "Настройки"
//                onClicked: currentScreen = 2
//                background: Rectangle {
//                    color: currentScreen === 2 ? "#007AFF" : "transparent"
//                    radius: 8
//                }
//            }
//        }
//    }

//    AddTaskForm {
//        id: taskFormPopup
//        fontName: robotoRegularFont.status === FontLoader.Ready ? robotoRegularFont.name : "Sans Serif"
//        onAddTask: (name, description, priority, category, dueDate) => {
//            if (formMode === "add") {
//                taskModel.addTaskFromStrings(name, description, priority)
//            } else if (formMode === "edit") {
//                taskModel.updateTask(editingTaskIndex, name, description, priority)
//            }
//            taskFormPopup.close()
//            editingTaskIndex = -1
//            formMode = "add"
//        }
//        onCancel: {
//            taskFormPopup.close()
//            editingTaskIndex = -1
//            formMode = "add"
//        }
//    }

