#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "task.h"
#include "TaskModel.h"
#include <QDebug>
#include <QDateTime>
#include <QModelIndex>

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

    TaskModel model;
    qDebug() << "[INIT] rowCount:" << model.rowCount();
    qDebug() << "[INIT] getTasks().size():" << model.getTasks().size();

    // 2. Добавление задач
    Task t1("Задача 1");
    t1.setDescription("Описание 1");
    t1.setPriority(1);
    Task t2("Задача 2");
    t2.setDescription("Описание 2");
    t2.setPriority(2);
    model.addTask(t1);
    qDebug() << "[ADD] Добавлена задача 1. rowCount:" << model.rowCount();
    model.addTask(t2);
    qDebug() << "[ADD] Добавлена задача 2. rowCount:" << model.rowCount();
    qDebug() << "[ADD] getTasks().size():" << model.getTasks().size();

    // 3. Проверка data()
    QModelIndex idx0 = model.index(0, 0);
    QModelIndex idx1 = model.index(1, 0);
    qDebug() << "[DATA] Имя задачи 0:" << model.data(idx0, TaskModel::NameRole).toString();
    qDebug() << "[DATA] Описание задачи 1:" << model.data(idx1, TaskModel::DescriptionRole).toString();
    qDebug() << "[DATA] Приоритет задачи 0:" << model.data(idx0, TaskModel::PriorityRole).toInt();

    // 4. Проверка getTask
    Task* taskPtr = model.getTask(0);
    qDebug() << "[GETTASK] getTask(0):" << (taskPtr ? taskPtr->toString() : "nullptr");

    // 5. Удаление задачи
    model.removeTask(0);
    qDebug() << "[REMOVE] После удаления задачи 0, rowCount:" << model.rowCount();
    if (model.getTask(0))
        qDebug() << "[REMOVE] Имя новой задачи 0:" << model.getTask(0)->getName();
    else
        qDebug() << "[REMOVE] getTask(0) == nullptr";

    // 6. Очистка модели
    model.clear();
    qDebug() << "[CLEAR] После очистки, rowCount:" << model.rowCount();
    qDebug() << "[CLEAR] getTasks().size():" << model.getTasks().size();

    // 7. Проверка на выход за границы
    qDebug() << "[OUT OF RANGE] getTask(0):" << (model.getTask(0) ? "NOT nullptr" : "nullptr");
    qDebug() << "[OUT OF RANGE] data(index(0,0), NameRole):" << model.data(model.index(0, 0), TaskModel::NameRole);

    // 8. Повторное добавление и проверка памяти
    model.addTask(t1);
    model.addTask(t2);
    qDebug() << "[RE-ADD] После повторного добавления, rowCount:" << model.rowCount();
    model.clear();
    qDebug() << "[RE-ADD] После повторной очистки, rowCount:" << model.rowCount();

    qDebug() << "TaskModel тесты успешно пройдены!";

    return 0;
}
