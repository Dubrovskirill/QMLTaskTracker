import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import "../styles" as Styles

Popup {
    id: taskFormPopup
    modal: true
    anchors.centerIn: Overlay.overlay
    width: Math.min(parent.width - 40, 400)
    height: contentColumn.implicitHeight + 40
    padding: 20
    closePolicy: Popup.NoAutoClose

    property string mode: "add"
    property string taskName: ""
    property string taskDescription: ""
    property int taskPriority: 1
    property string category: "" // Задел для категории
    property string dueDate: "" // Задел для срока выполнения
    property string fontName: "Sans Serif"

    signal addTask(string name, string description, int priority, string category, string dueDate)
    signal cancel()

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 200 }
        NumberAnimation { property: "scale"; from: 0.9; to: 1; duration: 200 }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 200 }
        NumberAnimation { property: "scale"; from: 1; to: 0.9; duration: 200 }
    }

    background: Rectangle {
        color: "#FFFFFF"
        radius: 10
        border.color: Material.dividerColor
        border.width: 1
    }

    ColumnLayout {
        id: contentColumn
        anchors.fill: parent
        spacing: 15

        Text {
            text: mode === "add" ? "Добавить новую задачу" : "Редактировать задачу"
            font.pixelSize: 18
            font.family: robotoExtraBoldFont.status === FontLoader.Ready ? robotoExtraBoldFont.name : fontName
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }

        TextField {
            id: nameField
            placeholderText: "Название задачи"
            Layout.fillWidth: true
            font.family: fontName
            font.pixelSize: Styles.Style.fontSizeMedium
        }

        TextArea {
            id: descriptionField
            placeholderText: "Описание задачи"
            Layout.fillWidth: true
            font.family: fontName
            font.pixelSize: Styles.Style.fontSizeMedium
            wrapMode: Text.Wrap
            implicitHeight: Math.max(100, contentHeight + 20)
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Repeater {
                model: ["Низкий", "Средний", "Высокий"]
                Button {
                    text: modelData
                    Layout.fillWidth: true
                    font.family: fontName
                    font.pixelSize: Styles.Style.fontSizeMedium
                    highlighted: taskPriority === index + 1
                    background: Rectangle {
                        color: highlighted ? "#007AFF" : "#E0E0E0"
                        radius: 5
                    }
                    onClicked: {
                        taskPriority = index + 1
                        scaleAnimator.start()
                    }
                    ScaleAnimator {
                        id: scaleAnimator
                        target: parent
                        from: 1.0
                        to: 0.95
                        duration: 100
                        easing.type: Easing.OutQuad
                        running: false
                    }
                }
            }
        }

        TextField {
            id: categoryField
            placeholderText: "Категория (неактивно)"
            Layout.fillWidth: true
            font.family: fontName
            font.pixelSize: Styles.Style.fontSizeMedium
            enabled: false
        }

        TextField {
            id: dueDateField
            placeholderText: "Срок выполнения"
            Layout.fillWidth: true
            font.family: fontName
            font.pixelSize: Styles.Style.fontSizeMedium
            enabled: false
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Button {
                text: mode === "add" ? "Добавить" : "Сохранить"
                Layout.fillWidth: true
                font.family: robotoBoldFont.status === FontLoader.Ready ? robotoBoldFont.name : fontName
                font.pixelSize: Styles.Style.fontSizeMedium
                background: Rectangle {
                    color: "#007AFF"
                    radius: 5
                }
                onClicked: {
                    if (nameField.text.trim() !== "") {
                        addTask(nameField.text, descriptionField.text, taskPriority, categoryField.text, dueDateField.text)
                    }
                }
                ScaleAnimator {
                    target: parent
                    from: 1.0
                    to: 0.95
                    duration: 100
                    easing.type: Easing.OutQuad
                    running: parent.pressed
                }
            }

            Button {
                text: "Отмена"
                Layout.fillWidth: true
                font.family: robotoBoldFont.status === FontLoader.Ready ? robotoBoldFont.name : fontName
                font.pixelSize: Styles.Style.fontSizeMedium
                background: Rectangle {
                    color: "#E0E0E0"
                    radius: 5
                }
                onClicked: {
                    cancel()
                }
                ScaleAnimator {
                    target: parent
                    from: 1.0
                    to: 0.95
                    duration: 100
                    easing.type: Easing.OutQuad
                    running: parent.pressed
                }
            }
        }
    }

    // Задел для динамического добавления полей
    Loader {
        id: dynamicFieldLoader
        anchors.fill: parent
        active: false
        source: ""
    }

    function syncFieldsToUI() {
        nameField.text = taskName
        descriptionField.text = taskDescription
        taskPriority = taskPriority // Уже синхронизировано через highlighted
        categoryField.text = category
        dueDateField.text = dueDate
    }

    onOpened: syncFieldsToUI()
}
