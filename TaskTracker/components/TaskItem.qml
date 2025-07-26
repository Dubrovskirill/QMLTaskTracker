import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

// Контейнер для одной задачи + кнопка "Удалить" справа
Item {
    id: container
    width: parent ? parent.width : 0
    height: 80

    // Пробросим сигналы наверх
    signal clicked(string taskName)
    signal requestDelete(int row)

    // Делаем горизонтальную разметку: задача слева, кнопка справа
    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        // Сама задача — кликабельная область
        Rectangle {
            id: taskItem
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: index % 2 === 0 ? "lightgray" : "white"
            border.color: "gray"
            border.width: 1
            radius: 8

            // Содержимое задачи
            Column {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                spacing: 4

                Text {
                    text: model.name
                    font.pixelSize: 16
                    font.bold: true
                    color: "black"
                }

                Text {
                    text: model.description
                    font.pixelSize: 12
                    color: "gray"
                }

                Text {
                    text: "Приоритет: " + ["Низкий", "Средний", "Высокий"][model.priority - 1] || "Средний"
                    font.pixelSize: 10
                    color: model.priority === 3 ? "red" : (model.priority === 1 ? "green" : "orange")
                }
            }

            // Клик по задаче → редактирование
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    container.clicked(model.name)
                    console.log("Клик по задаче:", model.name, "Индекс:", index)
                }
            }
        }

        // Кнопка "Удалить" — отдельно, не внутри taskItem
        Button {
            text: "Удалить"
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: 80
            Layout.preferredHeight: 40
            onClicked: {
                container.requestDelete(index)
            }
        }
    }
}
