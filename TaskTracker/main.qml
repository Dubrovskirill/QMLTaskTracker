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
            height: 50
            color: window.bgColor
            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Tasks"
                font.pointSize: 16
                color: window.textColor
                anchors.leftMargin: 30
            }
        }

        ListView {
            id: listView
            anchors.fill: parent
            spacing: defMargin
           // anchors.topMargin: defMargin
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

                dueDate: isoToDateTimeFormat(model.dueDate)

                statusColor: currentStatus(model.isCompleted)


                function isoToDateTimeFormat(isoString) {
                    if (!isoString) return ""

                    var date = new Date(isoString)
                    if (isNaN(date.getTime())) return ""

                    var day = ("0" + date.getDate()).slice(-2)
                    var month = ("0" + (date.getMonth() + 1)).slice(-2)  // Месяцы от 0
                    var year = date.getFullYear()
                    var hours = ("0" + date.getHours()).slice(-2)
                    var minutes = ("0" + date.getMinutes()).slice(-2)

                    return day + "." + month + "." + year + " " + hours + ":" + minutes
                }

                function currentStatus(status) {
                    if (status) return "transparent"

                    var dueDateStr = isoToDateTimeFormat(model.dueDate)
                    if (!dueDateStr) return "transparent"

                    var current = transDate(dueDateStr)
                    if (!current) return "transparent"

                    return new Date() > current ? "red" : "transparent"
                }

                function transDate(dateTimeStr) {
                    if (!dateTimeStr || typeof dateTimeStr !== "string") return null

                    var parts = dateTimeStr.trim().split(" ")
                    if (parts.length !== 2) return null

                    var datePart = parts[0]
                    var timePart = parts[1]

                    var dateParts = datePart.split(".")
                    var timeParts = timePart.split(":")

                    if (dateParts.length !== 3 || timeParts.length !== 2) return null

                    var day = parseInt(dateParts[0], 10)
                    var month = parseInt(dateParts[1], 10) - 1
                    var year = parseInt(dateParts[2], 10)
                    var hours = parseInt(timeParts[0], 10)
                    var minutes = parseInt(timeParts[1], 10)

                    if (isNaN(day) || isNaN(month) || isNaN(year) || isNaN(hours) || isNaN(minutes)) {
                        return null
                    }

                    var dateTime = new Date(year, month, day, hours, minutes)
                    return isNaN(dateTime.getTime()) ? null : dateTime
                }


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


