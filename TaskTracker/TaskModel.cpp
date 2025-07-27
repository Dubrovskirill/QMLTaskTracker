#include "TaskModel.h"

#include "task.h"
#include "TaskRepository.h"

TaskModel::TaskModel(QObject *parent)
    : QAbstractListModel(parent), m_repository(nullptr)
{
    qDebug() << "TaskModel: Конструктор";
}


TaskModel::~TaskModel()
{
    qDeleteAll(m_tasks);
    m_tasks.clear();
}

int TaskModel::rowCount(const QModelIndex &parent) const
{

    if (parent.isValid())
        return 0;
    return m_tasks.size();
}

QVariant TaskModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_tasks.size())
        return QVariant();

    Task* task = m_tasks.at(index.row());

    switch (role) {
    case IdRole:
        return task->getId();
    case NameRole:
        return task->getName();
    case DescriptionRole:
        return task->getDescription();
    case DueDateRole:
        return task->getDueDate();
    case IsCompletedRole:
        return task->isCompleted();
    case PriorityRole:
        return task->getPriority();
    case CreatedAtRole:
        return task->getCreatedAt();
    case UpdatedAtRole:
        return task->getUpdatedAt();
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> TaskModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[NameRole] = "name";
    roles[DescriptionRole] = "description";
    roles[DueDateRole] = "dueDate";
    roles[IsCompletedRole] = "isCompleted";
    roles[PriorityRole] = "priority";
    roles[CreatedAtRole] = "createdAt";
    roles[UpdatedAtRole] = "updatedAt";
    return roles;
}


void TaskModel::addTask(const Task &task)
{
    beginInsertRows(QModelIndex(), m_tasks.size(), m_tasks.size());
    m_tasks.append(new Task(task));
    endInsertRows();

    saveToRepository();
}

void TaskModel::removeTask(int row)
{
    if (row < 0 || row >= m_tasks.size())
        return;

    beginRemoveRows(QModelIndex(), row, row);
    delete m_tasks.at(row);
    m_tasks.removeAt(row);
    endRemoveRows();

    saveToRepository();
}

QVariant TaskModel::getTask(int row) const
{
    if (row < 0 || row >= m_tasks.size())
        return QVariant();

    Task *task = m_tasks.at(row);
    QVariantMap taskData;
    taskData["id"] = task->getId();
    taskData["name"] = task->getName();
    taskData["description"] = task->getDescription();
    taskData["priority"] = task->getPriority();
    taskData["dueDate"] = task->getDueDate();
    taskData["isCompleted"] = task->isCompleted();
    taskData["createdAt"] = task->getCreatedAt();
    taskData["updatedAt"] = task->getUpdatedAt();

    return taskData;
}

void TaskModel::clear()
{
    if (m_tasks.isEmpty())
        return;

    beginResetModel();
    qDeleteAll(m_tasks);
    m_tasks.clear();
    endResetModel();
}

QList<Task*> TaskModel::getTasks() const
{
    return m_tasks;
}

void TaskModel::addTaskFromStrings(const QString &name, const QString &description, int priority)
{
    Task task(name);
    task.setDescription(description);
    task.setPriority(priority);
    addTask(task); // используем уже существующий метод
}

void TaskModel::updateTask(int index, const QString &name, const QString &description, int priority)
{
    if (index < 0 || index >= m_tasks.size())
        return;
    Task* task = m_tasks.at(index);
    task->setName(name);
    task->setDescription(description);
    task->setPriority(priority);
    task->setUpdatedAt(QDateTime::currentDateTime());
    emit dataChanged(this->index(index), this->index(index));

    saveToRepository();
}

void TaskModel::saveToRepository()
{
    if (m_repository) {
        if (m_repository->saveTasks(this)) {
            qDebug() << "TaskModel: Задачи успешно сохранены";
        } else {
            qWarning() << "TaskModel: Ошибка при сохранении задач";
        }
    } else {
        qWarning() << "TaskModel: Репозиторий не установлен";
    }
}

void TaskModel::loadFromRepository()
{
    if (m_repository) {
        // Очищаем текущие данные
        beginResetModel();
        qDeleteAll(m_tasks);
        m_tasks.clear();
        endResetModel();

        // Загружаем новые данные
        if (m_repository->loadTasks(this)) {
            qDebug() << "TaskModel: Задачи успешно загружены";
        } else {
            qWarning() << "TaskModel: Ошибка при загрузке задач";
        }
    } else {
        qWarning() << "TaskModel: Репозиторий не установлен";
    }
}

void TaskModel::setRepository(TaskRepository *repo)
{
    m_repository = repo;
    qDebug() << "TaskModel: Репозиторий установлен";
}
