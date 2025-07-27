#ifndef TASKREPOSITORY_H
#define TASKREPOSITORY_H

#include <QObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QFile>
#include <QDir>


class Task;
class TaskModel;

class TaskRepository : public QObject
{
    Q_OBJECT

public:
    explicit TaskRepository(QObject *parent = nullptr);
    ~TaskRepository();

    // Основные методы для работы с данными
    bool loadTasks(TaskModel *taskModel);
    bool saveTasks(const TaskModel *taskModel);

    // Вспомогательные методы
    QJsonObject taskToJson(const Task *task) const;
    Task* jsonToTask(const QJsonObject &json) const;

    // Настройки файла
    void setFilePath(const QString &path);
    QString getFilePath() const;

private:
    QString m_filePath;
    static const QString DEFAULT_FILENAME;
};

#endif // TASKREPOSITORY_H
