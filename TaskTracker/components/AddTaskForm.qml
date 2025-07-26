import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: container
    width: parent.width
    height: 200

    // Экспортируем свойства наружу
    property alias mode: addTaskForm.mode
    property alias taskName: addTaskForm.taskName
    property alias taskDescription: addTaskForm.taskDescription
    property alias taskPriority: addTaskForm.taskPriority

    signal addTask(string name, string description, int priority)
    signal cancel()

    Rectangle {
        id: addTaskForm
        anchors.fill: parent
        color: "lightyellow"
        border.color: "gray"
        border.width: 1

        // Внутренние свойства
        property string mode: "add"
        property string taskName: ""
        property string taskDescription: ""
        property int taskPriority: 1

        // Авто-обновление полей при изменении данных
        onModeChanged: syncFieldsToUI()
        onTaskNameChanged: if (visible) nameField.text = taskName
        onTaskDescriptionChanged: if (visible) descriptionField.text = taskDescription
        onTaskPriorityChanged: {
            if (visible) {
                priorityCombo.currentIndex = taskPriority >= 1 && taskPriority <= 3 ? taskPriority - 1 : 0
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Text {
                text: mode === "add" ? "Добавить новую задачу" : "Редактировать задачу"
                font.pixelSize: 16
                font.bold: true
            }

            TextField {
                id: nameField
                placeholderText: "Название задачи"
                Layout.fillWidth: true
            }

            TextField {
                id: descriptionField
                placeholderText: "Описание задачи"
                Layout.fillWidth: true
            }

            ComboBox {
                id: priorityCombo
                model: ["Низкий", "Средний", "Высокий"]
                Layout.fillWidth: true
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Button {
                    text: mode === "add" ? "Добавить" : "Сохранить"
                    Layout.fillWidth: true
                    onClicked: {
                        if (nameField.text.trim() !== "") {
                            container.addTask(
                                nameField.text,
                                descriptionField.text,
                                priorityCombo.currentIndex + 1
                            )
                        }
                    }
                }

                Button {
                    text: "Отмена"
                    Layout.fillWidth: true
                    onClicked: container.cancel()
                }
            }
        }

        // Принудительно обновляем поля при открытии
        function syncFieldsToUI() {
            nameField.text = taskName
            descriptionField.text = taskDescription
            priorityCombo.currentIndex = taskPriority >= 1 && taskPriority <= 3 ? taskPriority - 1 : 0
        }

        onVisibleChanged: {
            if (visible) syncFieldsToUI()
        }
    }

    // Управление видимостью
    visible: false
    z: 10
}
