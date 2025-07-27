import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: container
    width: parent ? parent.width : 0
    height: 80

    signal clicked(string taskName)
    signal requestDelete(int row)

    property string fontName: "Sans Serif"

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Rectangle {
            id: taskItem
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: index % 2 === 0 ? "lightgray" : "white"
            border.color: "gray"
            border.width: 1
            radius: 8

            Column {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                spacing: 4

                Text {
                    text: model.name
                    font.pixelSize: 16
                    font.family: fontName
                    font.bold: true
                    color: "black"
                }

                Text {
                    text: model.description
                    font.pixelSize: 12
                    font.family: robotoLightFont.status === FontLoader.Ready ? robotoLightFont.name : fontName
                    color: "gray"
                }

                Text {
                    text: "Приоритет: " + ["Низкий", "Средний", "Высокий"][model.priority - 1] || "Средний"
                    font.pixelSize: 10
                    font.family: robotoLightFont.status === FontLoader.Ready ? robotoLightFont.name : fontName
                    color: model.priority === 3 ? "red" : (model.priority === 1 ? "green" : "orange")
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    container.clicked(model.name)
                    console.log("Клик по задаче:", model.name, "Индекс:", index)
                }
            }
        }

        Button {
            text: "Удалить"
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: 80
            Layout.preferredHeight: 40
            font.family: robotoBoldFont.status === FontLoader.Ready ? robotoBoldFont.name : fontName
            onClicked: {
                container.requestDelete(index)
            }
        }
    }
}
