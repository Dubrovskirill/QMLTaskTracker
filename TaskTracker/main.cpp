#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include <QDateTime>
#include <QModelIndex>
#include <QQmlContext>
#include <QQmlEngine> // Добавлено для qmlRegisterType

#include "task.h"
#include "TaskModel.h"
#include "TaskRepository.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    // Регистрация Task для использования в QML
    qmlRegisterType<Task>("TaskTracker", 1, 0, "Task");

    QQmlApplicationEngine engine;

    TaskModel taskModel;
    TaskRepository repository; // Добавляем репозиторий

    // Загружаем задачи при запуске
    if (!repository.loadTasks(&taskModel)) {
        qWarning() << "Не удалось загрузить задачи";
    }
    engine.rootContext()->setContextProperty("taskModel", &taskModel);
    engine.rootContext()->setContextProperty("repository", &repository);


    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    QObject::connect(&app, &QGuiApplication::aboutToQuit, [&]() {
        if (!repository.saveTasks(&taskModel)) {
            qWarning() << "Не удалось сохранить задачи";
        }
    });

    return app.exec();
}
