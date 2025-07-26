import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: addTaskForm
    width: parent.width
    height: 200
    color: "lightyellow"
    border.color: "gray"
    border.width: 1

    // Сигнал для добавления задачи
    signal addTask(string name, string description, int priority)
    signal cancel()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Text {
            text: "Добавить новую задачу"
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
            currentIndex: 1 // Средний по умолчанию
            Layout.fillWidth: true
        }

        RowLayout {
            Layout.fillWidth: true

            Button {
                text: "Добавить"
                Layout.fillWidth: true
                onClicked: {
                    if (nameField.text.trim() !== "") {
                        addTaskForm.addTask(
                            nameField.text,
                            descriptionField.text,
                            priorityCombo.currentIndex + 1
                        )
                        nameField.text = ""
                        descriptionField.text = ""
                        priorityCombo.currentIndex = 1
                    }
                }
            }

            Button {
                text: "Отмена"
                Layout.fillWidth: true
                onClicked: {
                    addTaskForm.cancel()
                }
            }
        }
    }
}
