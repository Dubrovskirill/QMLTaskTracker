#ifndef TASKMODEL_H
#define TASKMODEL_H

#include <QAbstractListModel>
#include <QList>

class Task;
class TaskRepository;



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
    Q_INVOKABLE QVariant getTask(int row) const;
    Q_INVOKABLE void clear();
    Q_INVOKABLE void addTaskFromStrings(const QString &name, const QString &description, int priority);
    Q_INVOKABLE void updateTask(int index, const QString &name, const QString &description, int priority);
    Q_INVOKABLE void saveToRepository();
    Q_INVOKABLE void loadFromRepository();
    Q_INVOKABLE void setRepository(TaskRepository *repo);

    QList<Task*> getTasks() const;
    void updateLastId(int id);

private:
    QList<Task*> m_tasks;
    TaskRepository *m_repository;
    int m_lastId;

};

#endif // TASKMODEL_H
