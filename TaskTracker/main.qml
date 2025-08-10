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
    function popPage(targetPageName) {
        stackView.pop(targetPageName);
    }

    Page {
        id: mainPage
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
                id: taskItem
                height: 80
                width: mainPage.width
                anchors.topMargin: defMargin
                anchors.bottomMargin: defMargin

                name: model.name
                descr: model.description
                priority: model.priority === 3 ? "red" : (model.priority === 1 ? "green" : "orange")


                Connections {
                    target: taskItem
                    function onRequestDelete(index) {
                        taskModel.removeTask(index)
                    }
                }
            }
        }


        footer: NavigationMenu {
            onNewTask: {
                console.log("Полученно")
                stackView.push(infoTaskPageComponent)

            }
        }
    }

    Component {
        id: infoTaskPageComponent

        InfoTaskPage {
            id: infoTaskPage
            Connections {
                target: infoTaskPage
                function onAddTask(name, description, priority, dueDate) {
                    taskModel.addTaskFromStrings(name, description, priority, dueDate)
                }
                function onEditTask(row,name, description, priority, dueDate) {
                    taskModel.updateTask(row,name, description, priority, dueDate)
                }
            }

        }
    }


}


