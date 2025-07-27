pragma Singleton
import QtQuick 2.15

QtObject {
    // Тема: true = светлая, false = темная
    property bool isLightTheme: true

    // Цвета для светлой и темной темы
    readonly property color backgroundColor: isLightTheme ? "#F5F5F5" : "#1C2526"
    readonly property color cardBackground: isLightTheme ? "#FFFFFF" : "#2A3439"
    readonly property color textPrimary: isLightTheme ? "#000000" : "#FFFFFF"
    readonly property color textSecondary: isLightTheme ? "#666666" : "#BBBBBB"
    readonly property color accentColor: "#007AFF" // Синий для кнопок и акцентов
    readonly property color borderColor: isLightTheme ? "#E0E0E0" : "#444444"

    // Цвета приоритетов
    readonly property color priorityLow: "#34C759"    // Зеленый
    readonly property color priorityMedium: "#FF9500"  // Оранжевый
    readonly property color priorityHigh: "#FF3B30"    // Красный

    // Шрифты
    readonly property int fontSizeLarge: 24    // Для заголовков
    readonly property int fontSizeMedium: 16   // Для основного текста
    readonly property int fontSizeSmall: 12    // Для второстепенного текста
    property string fontFamily: "Sans Serif" // Запасной шрифт

    // Функция для установки шрифта из main.qml
    function setFontFamily(fontName) {
        fontFamily = fontName
        console.log("Шрифт установлен в Style.qml: " + fontName)
    } // Подгружается через FontLoader

    // Отступы
    readonly property int spacingSmall: 8
    readonly property int spacingMedium: 16
    readonly property int spacingLarge: 24

    // Радиусы и тени
    readonly property int cornerRadius: 8
    readonly property real shadowOpacity: isLightTheme ? 0.2 : 0.4
    readonly property int shadowRadius: 4
    readonly property int shadowOffset: 2

    // Функция для переключения темы
    function toggleTheme() {
        isLightTheme = !isLightTheme
    }
}
