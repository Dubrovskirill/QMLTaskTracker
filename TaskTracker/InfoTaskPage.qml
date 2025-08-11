import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15


Page {
    id: root
    property string mode: "add"
    property int taskIndex: -1

    property string taskName: ""
    property string taskDescription: ""
    property int taskPriority: 1
    property date taskDueDateTime: undefined
    property string taskDueDate: ""
    property string taskDueTime: ""
    property bool taskStatus: false

    property bool isCurrentDate: false

    property date taskCreatedAt: undefined
    property date taskUpdatedAt: undefined


    background: Rectangle {
        color: window.bgColor
    }

    Component.onCompleted: {
        var taskData = taskModel.getTask(taskIndex)
        taskName = taskData.name || ""
        taskDescription = taskData.description || ""
        taskPriority = taskData.priority || 1
        taskDueDateTime = taskData.dueDate || undefined

        if (taskData.dueDate !== "") {
            taskDueDate = isoToDateFormat(taskData.dueDate)
            taskDueTime = isoToTimeFormat(taskData.dueDate)
        } else {
            taskDueDate = ""
            taskDueTime = ""
        }

        taskCreatedAt = taskData.createdAt || undefined
        taskUpdatedAt = taskData.updatedAt || undefined

        taskStatus = taskData.isCompleted || false
    }
    signal addTask(string name, string description, int priority, var dueDate)
    signal editTask(int row, string name, string description, int priority, var dueDate)


    header: ToolBar {
        id:toolBar

        background: Rectangle {
            color: window.bgColor
        }
        height: 50
        ToolButton {
            id:btnBack
            text: "<"
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                popPage();
            }
            width: 50
            height: width
            contentItem: Text {
                text: parent.text
                width: parent.width
                height: parent.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: window.textColor
                font.pixelSize: 32

            }
            background: Rectangle {
                color: window.bgColor
            }

        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: btnBack.right
            text: mode === "add" ? "New task" : "Info"
            font.pointSize: 16
            color: window.textColor
            anchors.leftMargin: 30
        }

    }

    Rectangle {
        id:rectForm
        color: window.taskColor
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.bottomMargin: 360
        radius: 20

        ColumnLayout {
            id: contentColumn
            anchors.fill: parent
            anchors.margins: 15
            spacing: 17

            Label {
                id: lblName
                Layout.fillWidth: true
                text: "Title"
                padding: 0

                color: Qt.darker(window.textColor, 1.5)
                font.pixelSize: 15

            }

            TextField {
                id: nameText
                text: taskName
                selectByMouse: true
                placeholderText: "Task name"
                Layout.fillWidth: true
                padding: 0
                leftPadding: 0
                rightPadding: 0
                topPadding: 0
                bottomPadding: 0
                font.pixelSize: 16
                color: window.textColor
                background: Rectangle {
                    color: rectForm.color
                }
            }
            Rectangle {
                color: "lightgrey"
                Layout.fillWidth: true
                height: 1
            }

            Label {
                id: lblDesc
                Layout.fillWidth: true
                text: "Description"
                padding: 0

                color: Qt.darker(window.textColor, 1.5)
                font.pixelSize: 15

            }

            Flickable {
                id: flickable
                Layout.fillWidth: true
                width: parent.width
                height: descriptionText.font.pixelSize*2.5
                contentWidth: width
                contentHeight: descriptionText.implicitHeight

                TextArea.flickable: TextArea {
                    id: descriptionText
                    text: taskDescription
                    selectByMouse: true
                    placeholderText: "Task description"
                    Layout.fillWidth: true
                    padding: 0
                    leftPadding: 0
                    rightPadding: 0
                    topPadding: 0
                    bottomPadding: 0
                    font.pixelSize: 16
                    color: window.textColor

                    wrapMode: Text.Wrap
                    background: Rectangle {
                        color: rectForm.color
                    }
                }
                ScrollBar.vertical: ScrollBar {}
            }
            Rectangle {
                color: "lightgrey"
                Layout.fillWidth: true
                height: 1
            }

            Label {
                id: lblPriority
                Layout.fillWidth: true
                text: "Priority"
                padding: 0

                color: Qt.darker(window.textColor, 1.5)
                font.pixelSize: 15

            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 50
                Repeater {
                    model: ["Low", "Medium", "High"]
                    Button {
                        text: modelData
                        Layout.fillWidth: true
                        highlighted: taskPriority === index + 1
                        Layout.preferredWidth: 100
                        Layout.preferredHeight: 30
                        background: Rectangle {
                            color: highlighted ? (taskPriority === 3 ? "red" : (taskPriority === 1 ? "green" : "orange")) : "#393c43"

                            radius: 11
                        }
                        contentItem: Text {
                            text: parent.text
                            width: parent.width
                            height: parent.height
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: window.textColor
                            font.pixelSize: 16

                        }
                        onClicked: {
                            taskPriority = index + 1
                        }

                    }
                }
            }

            Rectangle {
                color: "lightgrey"
                Layout.fillWidth: true
                height: 1
            }



            RowLayout {
                Layout.fillWidth: true
                spacing: 50

                Column {


                    spacing: 17
                    Label {
                        id: lblDueDate
                        Layout.fillWidth: true
                        text: "Due date"
                        padding: 0

                        color: Qt.darker(window.textColor, 1.5)
                        font.pixelSize: 15

                    }

                    TextField {
                        id: dueDateText
                        property bool showError: false
                        text: taskDueDate
                        selectByMouse: true
                        placeholderText: "dd.mm.yyyy"
                        Layout.fillWidth: true
                        padding: 0
                        leftPadding: 0
                        rightPadding: 0
                        topPadding: 0
                        bottomPadding: 0
                        font.pixelSize: 16
                        color: window.textColor

                        background: Rectangle {

                            color: rectForm.color


                            border.color:  window.taskColor

                            border.width: 1

                        }
                        function updateBorderColor() {
                            if (!dueDateText.focus && !isValidDate(dueDateText.text) && dueDateText.text.length > 0 && taskStatus===false) {
                                dueDateText.background.border.color = "red"
                            } else if (dueDateText.focus && dueDateText.text.length === 10 && !isValidDate(dueDateText.text)) {
                                dueDateText.background.border.color = "red"
                            } else {
                                dueDateText.background.border.color = window.taskColor
                            }
                        }
                        onTextChanged: {
                            dueDateText.updateBorderColor()
                            dueTimeText.updateBorderColor()

                            console.log(dueDateText.text + " " + dueTimeText.text)
                        }

                        onFocusChanged: {
                            if (dueDateText.focus) {
                                dueDateText.inputMask = "99.99.9999;"
                            }

                            if (!dueDateText.focus && dueDateText.text === "..") {
                                dueDateText.inputMask = ""
                            }
                            dueDateText.updateBorderColor()
                            dueTimeText.updateBorderColor()
                        }

                    }
                }
                Column {



                    spacing: 17
                    Label {
                        id: lblDueTime
                        Layout.fillWidth: true
                        text: "Due time"
                        padding: 0

                        color: Qt.darker(window.textColor, 1.5)
                        font.pixelSize: 15

                    }

                    TextField {
                        id: dueTimeText
                        property bool showError: false
                        text: taskDueTime
                        selectByMouse: true
                        //enabled: (isValidDate(dueDateText.text) && dueDateText.text.length !== 0) ? true : false
                        placeholderText: "hh:mm"
                        Layout.fillWidth: true
                        padding: 0
                        leftPadding: 0
                        rightPadding: 0
                        topPadding: 0
                        bottomPadding: 0
                        font.pixelSize: 16
                        color: window.textColor

                        background: Rectangle {

                            color: rectForm.color
                            border.color: window.taskColor

                            border.width: 1
                        }
                        function updateBorderColor() {
                            if (!dueTimeText.focus && !isValidTime(dueTimeText.text) && dueTimeText.text.length > 0 && taskStatus===false) {
                                dueTimeText.background.border.color = "red"
                            } else if (dueTimeText.focus && dueTimeText.text.length === 5 && !isValidTime(dueTimeText.text)) {
                                dueTimeText.background.border.color = "red"
                            } else {
                                dueTimeText.background.border.color = window.taskColor
                            }
                        }
                        onTextChanged: {
                            updateBorderColor()
                        }

                        onFocusChanged: {
                            if (dueTimeText.focus) {
                                dueTimeText.inputMask = "99:99;"
                            }

                            if (!dueTimeText.focus && dueTimeText.text === ":") {
                                dueTimeText.inputMask = ""
                            }
                            updateBorderColor()

                        }
                    }
                }
            }
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }

    Rectangle {
        id:rectFormInfo
        color: window.taskColor


        anchors.top: rectForm.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 20
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.bottomMargin: 235

        visible: mode === "add" ? false : true
        radius: 20
        ColumnLayout {
            id: infotColumn
            anchors.fill: parent
            anchors.margins: 15
            spacing: 17
           RowLayout{
               Layout.fillWidth: true
               spacing: 20
                Label {
                    id: lblStatus
                   // Layout.fillWidth: true
                    function currentStatus(status) {
                        if (status){
                            rectStatus.color = "green"
                            return "Task is completed"
                        } else {
                            var now = new Date()
                            var current = combineDateAndTime(dueDateText.text, dueTimeText.text )
                            if (now >= current && dueDateText.text.length !== 0 && dueTimeText.text.length !== 0) {
                                rectStatus.color = "red"
                                return "Task is overdue"
                            }
                        }
                        rectStatus.color = "blue"
                        return "Task in progress"
                    }

                    text: "Status: " + currentStatus(taskStatus)
                    padding: 0

                    color: Qt.darker(window.textColor, 1.5)
                    font.pixelSize: 15

                }
                Rectangle {
                    id: rectStatus
                    Layout.fillWidth: true
                    height: 5
                    radius: 2
                    color: "red"
                }
            }


            Rectangle {
                color: "lightgrey"
                Layout.fillWidth: true
                height: 1
            }

            Row {
                Layout.fillWidth: true
                spacing: 20
                Label {
                    id: lblCreatedAt

                    text: "Created at: " + isoToDateFormat(taskCreatedAt) + " " + isoToTimeFormat(taskCreatedAt)
                    padding: 0

                    color: Qt.darker(window.textColor, 1.5)
                    font.pixelSize: 15

                }
                Label {


                    text: "Updated at: " + isoToDateFormat(taskUpdatedAt) + " " + isoToTimeFormat(taskUpdatedAt)
                    padding: 0

                    color: Qt.darker(window.textColor, 1.5)
                    font.pixelSize: 15

                }

            }
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

        }


    }


    footer: Rectangle {
        height: 60
        color: window.bgColor
        Button {
            id: btnAddTask
            text: qsTr("Done")
            anchors.centerIn: parent
            padding: 0
            enabled: nameText.text.length > 0 && ( dueDateText.text.length === 0 || isValidDate(dueDateText.text)) && ( dueTimeText.text.length === 0 || isValidTime(dueTimeText.text))
            onClicked: {
                if (isValidDate(dueDateText.text) && isValidTime(dueTimeText.text)) {
                    taskDueDateTime = combineDateAndTime(dueDateText.text, dueTimeText.text )
                } else if (isValidDate(dueDateText.text)) {
                    taskDueDateTime = combineDateAndTime(dueDateText.text, "23:59" )
                } else taskDueDateTime = ""


                mode === "add" ? addTask(nameText.text, descriptionText.text, taskPriority, taskDueDateTime)
                               : editTask(taskIndex, nameText.text, descriptionText.text, taskPriority, taskDueDateTime)
                popPage(mainPage)
            }

            width: 100
            height: 40



            contentItem: Text {
                text: parent.text
                color: window.bgColor
                padding: 0

                font.pixelSize: 20
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenterOffset: -1.5

            }

            background: Rectangle {
                color: btnAddTask.down || !btnAddTask.enabled ? Qt.darker(window.textColor, 2) : window.textColor
                width: parent.width
                height: parent.height
                radius: 11
            }
        }
    }





    function isValidDate(dateString) {
        root.isCurrentDate = false
        // Ожидаем формат dd:MM:yyyy
        var regex = /^(\d{2}).(\d{2}).(\d{4})$/
        var match = dateString.match(regex)
        if (!match) return false


        var day = parseInt(match[1], 10)
        var month = parseInt(match[2], 10) - 1 // Месяцы в JS от 0 до 11
        var year = parseInt(match[3], 10)

        // Проверяем, что значения в допустимых диапазонах
        if (day < 1 || day > 31 || month < 0 || month > 11 || year < 1000) {
            return false
        }

        // Создаём объект Date
        var inputDate = new Date(year, month, day)
        if (isNaN(inputDate.getTime())) {
            return false // Неверная дата (например, 31 февраля)
        }
        var now = new Date()
        var currentDay = now.getDate()
        var currentMonth = now.getMonth()
        var currentYear = now.getFullYear()

        day = inputDate.getDate()
        month = inputDate.getMonth()
        year = inputDate.getFullYear()


        if (year < currentYear) return false
        if (year === currentYear && month < currentMonth) return false
        console.log(inputDate+" "+now)
        console.log(day+" "+currentDay)
        console.log(month+" "+currentMonth)
        console.log(year+" "+currentYear)
        if (year === currentYear && month === currentMonth && day < currentDay) return false
        if (year === currentYear && month === currentMonth && day === currentDay) root.isCurrentDate = true
        return true
    }


    function isValidTime(timeString, dateString) {

        // Проверяем формат: hh:mm
        var regex = /^(\d{2}):(\d{2})$/
        var match = timeString.match(regex)
        if (!match) return false

        var hours = parseInt(match[1], 10)
        var minutes = parseInt(match[2], 10)

        // Проверяем диапазон
        if (hours < 0 || hours > 23) return false
        if (minutes < 0 || minutes > 59) return false


        if (!isCurrentDate) return true
        var now = new Date()
        var currentHours = now.getHours()
        var currentMinutes = now.getMinutes()

        // Сравниваем: если часы меньше текущих — невалидно
        // Если часы равны — проверяем минуты
        if (hours < currentHours) return false
        if (hours === currentHours && minutes < currentMinutes) return false

        return true
    }

    function combineDateAndTime(dateStr, timeStr) {
        // Разбираем дату: dd.MM.yyyy
        var dateParts = dateStr.split(".");
        if (dateParts.length !== 3) return null;
        var day = parseInt(dateParts[0], 10);
        var month = parseInt(dateParts[1], 10) - 1; // Месяцы в JS: 0–11
        var year = parseInt(dateParts[2], 10);

        // Разбираем время: hh:mm
        var timeParts = timeStr.split(":");
        if (timeParts.length !== 2) return null;
        var hours = parseInt(timeParts[0], 10);
        var minutes = parseInt(timeParts[1], 10);

        // Создаём объект Date
        var dateTime = new Date(year, month, day, hours, minutes);

        // Проверяем, валидна ли дата (защита от некорректных значений, например 32.13.9999)
        if (isNaN(dateTime.getTime())) {
            return null;
        }

        return dateTime;
    }


    function isoToDateFormat(isoString) {
        if (!isoString) return ""

        var date = new Date(isoString)
        if (isNaN(date.getTime())) return ""

        var day = ("0" + date.getDate()).slice(-2)
        var month = ("0" + (date.getMonth() + 1)).slice(-2)  // Месяцы от 0
        var year = date.getFullYear()

        return day + "." + month + "." + year
    }

    function isoToTimeFormat(isoString) {
        if (!isoString) return ""

        var date = new Date(isoString)
        if (isNaN(date.getTime())) return ""

        var hours = ("0" + date.getHours()).slice(-2)
        var minutes = ("0" + date.getMinutes()).slice(-2)

        return hours + ":" + minutes
    }

    Keys.onEscapePressed: {

        popPage(mainPage)

    }
}
