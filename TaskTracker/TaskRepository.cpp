#include <QStandardPaths>
#include <QDebug>

#include "TaskRepository.h"
#include "task.h"        // Теперь включаем здесь
#include "TaskModel.h"

const QString TaskRepository::DEFAULT_FILENAME = "tasks.json";

TaskRepository::TaskRepository(QObject *parent)
    : QObject(parent)
{
    // Устанавливаем путь к файлу в папке приложения
    QString appDataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(appDataPath); // Создаем папку если её нет
    m_filePath = appDataPath + "/" + DEFAULT_FILENAME;
    qDebug() << "TaskRepository: Файл данных:" << m_filePath;
}

TaskRepository::~TaskRepository()
{
    qDebug() << "TaskRepository: Деструктор";
}

bool TaskRepository::loadTasks(TaskModel *taskModel)
{
    if (!taskModel) {
        qWarning() << "TaskRepository: TaskModel не передан";
        return false;
    }

    QFile file(m_filePath);
    if (!file.exists()) {
        qDebug() << "TaskRepository: Файл не найден, создаем новый";
        return true; // Не ошибка, просто файл не существует
    }

    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "TaskRepository: Не удалось открыть файл для чтения:" << m_filePath;
        return false;
    }

    QJsonParseError error;
    QJsonDocument doc = QJsonDocument::fromJson(file.readAll(), &error);
    if (error.error != QJsonParseError::NoError) {
        qWarning() << "TaskRepository: Ошибка парсинга JSON:" << error.errorString();
                                                                               return false;
    }

    QJsonArray tasksArray = doc.array();
    qDebug() << "TaskRepository: Загружено задач:" << tasksArray.size();

        for (const QJsonValue &value : tasksArray) {
        if (value.isObject()) {
            Task *task = jsonToTask(value.toObject());
            if (task && task->isValid()) {
                taskModel->addTask(*task);
                delete task; // Освобождаем память
            }
        }
    }

    qDebug() << "TaskRepository: Загрузка завершена";
    return true;
}

bool TaskRepository::saveTasks(const TaskModel *taskModel)
{
    if (!taskModel) {
        qWarning() << "TaskRepository: TaskModel не передан";
        return false;
    }

    QJsonArray tasksArray;
    QList<Task*> tasks = taskModel->getTasks();

    for (const Task *task : tasks) {
        if (task && task->isValid()) {
            tasksArray.append(taskToJson(task));
        }
    }

    QJsonDocument doc(tasksArray);
    QFile file(m_filePath);

    if (!file.open(QIODevice::WriteOnly)) {
        qWarning() << "TaskRepository: Не удалось открыть файл для записи:" << m_filePath;
        return false;
    }

    file.write(doc.toJson());
    qDebug() << "TaskRepository: Сохранено задач:" << tasksArray.size();
        return true;
}

QJsonObject TaskRepository::taskToJson(const Task *task) const
{
    QJsonObject json;
    json["id"] = task->getId();
    json["name"] = task->getName();
    json["description"] = task->getDescription();
    json["dueDate"] = task->getDueDate().toString(Qt::ISODate);
    json["isCompleted"] = task->isCompleted();
    json["priority"] = task->getPriority();
    json["createdAt"] = task->getCreatedAt().toString(Qt::ISODate);
    json["updatedAt"] = task->getUpdatedAt().toString(Qt::ISODate);
    return json;
}

Task* TaskRepository::jsonToTask(const QJsonObject &json) const
{
    Task *task = new Task();

    task->setId(json["id"].toInt());
    task->setName(json["name"].toString());
    task->setDescription(json["description"].toString());

    QDateTime dueDate = QDateTime::fromString(json["dueDate"].toString(), Qt::ISODate);
    task->setDueDate(dueDate);

    task->setIsCompleted(json["isCompleted"].toBool());
    task->setPriority(json["priority"].toInt());

    QDateTime createdAt = QDateTime::fromString(json["createdAt"].toString(), Qt::ISODate);
    task->setCreatedAt(createdAt);

    QDateTime updatedAt = QDateTime::fromString(json["updatedAt"].toString(), Qt::ISODate);
    task->setUpdatedAt(updatedAt);

    return task;
}

void TaskRepository::setFilePath(const QString &path)
{
    m_filePath = path;
}

QString TaskRepository::getFilePath() const
{
    return m_filePath;
}
