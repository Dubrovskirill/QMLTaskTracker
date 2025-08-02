import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

Page {
    id: root


    property string mode: "add"
    property string taskName: ""
    property string taskDescription: ""
    property int taskPriority: 1
    background: Rectangle {
        color: window.bgColor
    }

    function syncFieldsToUI() {
        nameText.text = taskName
        descriptionText.text = taskDescription
        taskPriority = taskPriority
    }
    signal addTask(string name, string description, int priority)
    signal editTask(string name, string description, int priority)


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
            text: mode === "add" ? "New task" : "Edit task"
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
        anchors.bottomMargin: 250
        radius: 20

        ColumnLayout {
            id: contentColumn
            anchors.fill: parent
            anchors.margins: 15
            spacing: 20

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
                height: Math.min(contentHeight, descriptionText.font.pixelSize*1.19)
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
                            color: highlighted ? "#007AFF" : "#393c43"

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
            enabled: nameText.text.length > 0
            onClicked: {

                mode === "add" ? addTask(nameText.text, descriptionText.text, taskPriority): editTask(nameText.text, descriptionText.text, taskPriority)
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

    Keys.onEscapePressed: {

        popPage()

    }
}
