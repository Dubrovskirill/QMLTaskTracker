#ifndef TASKMODEL_H
#define TASKMODEL_H

#include <QAbstractListModel>
#include <QList>
#include "task.h"


class TaskModel :public QAbstractListModel
{
    Q_OBJECT
public:
    explicit TaskModel(QObject *parent = nullptr);
    ~TaskModel();

    enum TaskRoles {
        IdRole = Qt::UserRole + 1,
        NameRole,
        DescriptionRole,
        DueDateRole,
        IsCompletedRole,
        PriorityRole,
        CreatedAtRole,
        UpdatedAtRole
    };
    Q_ENUM(TaskRoles)

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;


    Q_INVOKABLE void addTask(const Task &task);
    Q_INVOKABLE void removeTask(int row);
    Q_INVOKABLE Task* getTask(int row) const;
    Q_INVOKABLE void clear();


    QList<Task*> getTasks() const;

private:
    QList<Task*> m_tasks;

};

#endif // TASKMODEL_H
