#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "task.h"
#include <QDebug>
#include <QDateTime>

int main(int argc, char *argv[])
{
//#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
//    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
//#endif
//    QGuiApplication app(argc, argv);

//    QQmlApplicationEngine engine;
//    const QUrl url(QStringLiteral("qrc:/main.qml"));
//    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
//        &app, [url](QObject *obj, const QUrl &objUrl) {
//            if (!obj && url == objUrl)
//                QCoreApplication::exit(-1);
//        }, Qt::QueuedConnection);
//    engine.load(url);

    // Тест 1: Конструктор по умолчанию
    Task t1;
    qDebug() << "t1:" << t1.toString();
    Q_ASSERT(!t1.isOverdue());
    Q_ASSERT(!t1.isValid()); // имя пустое

    // Тест 2: Конструктор с именем
    Task t2("Сделать домашку");
    qDebug() << "t2:" << t2.toString();
    Q_ASSERT(t2.getName() == "Сделать домашку");
    Q_ASSERT(t2.isValid());

    // Тест 3: setDescription и getDescription
    t2.setDescription("Подробное описание");
    Q_ASSERT(t2.getDescription() == "Подробное описание");

    // Тест 4: setCreatedAt и setUpdatedAt
    QDateTime now = QDateTime::currentDateTime();
    t2.setCreatedAt(now);
    t2.setUpdatedAt(now.addSecs(60));
    Q_ASSERT(t2.getCreatedAt() == now);
    Q_ASSERT(t2.getUpdatedAt() == now.addSecs(60));

    // Тест 5: Проверка срока и просроченности
    t2.setDueDate(QDateTime::currentDateTime().addSecs(-3600)); // срок в прошлом
    Q_ASSERT(t2.isOverdue());

    // Тест 6: completed
    t2.setIsCompleted(true);
    Q_ASSERT(!t2.isOverdue());

    // Тест 7: Приоритет
    t2.setPriority(1);
    Q_ASSERT(t2.getPriority() == 1);

    // Тест 8: Некорректный приоритет
    t2.setPriority(10);
    Q_ASSERT(!t2.isValid());
    t2.setPriority(2); // вернём корректный

    // Тест 9: Некорректный id
    t2.setId(-5);
    Q_ASSERT(!t2.isValid());
    t2.setId(0); // вернём корректный

    // Тест 10: Пустое имя с пробелами
    t2.setName("   ");
    Q_ASSERT(!t2.isValid());
    t2.setName("Сделать домашку"); // вернём корректное

    // Тест 11: Копирование задачи
    Task t3(t2);
    Q_ASSERT(t3.getName() == t2.getName());
    Q_ASSERT(t3.getId() == t2.getId());
    Q_ASSERT(t3.getDescription() == t2.getDescription());
    Q_ASSERT(t3.getDueDate() == t2.getDueDate());
    Q_ASSERT(t3.isCompleted() == t2.isCompleted());
    Q_ASSERT(t3.getPriority() == t2.getPriority());
    Q_ASSERT(t3.getCreatedAt() == t2.getCreatedAt());
    Q_ASSERT(t3.getUpdatedAt() == t2.getUpdatedAt());

    // Тест 12: toString с разными комбинациями
    qDebug() << t2.toString();
    t2.setDescription("");
    qDebug() << t2.toString();


    return 0;
}
