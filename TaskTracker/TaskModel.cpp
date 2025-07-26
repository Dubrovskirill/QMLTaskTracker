#include "TaskModel.h"

TaskModel::TaskModel(QObject *parent)
    : QAbstractListModel(parent)
{}


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
}

void TaskModel::removeTask(int row)
{
    if (row < 0 || row >= m_tasks.size())
        return;

    beginRemoveRows(QModelIndex(), row, row);
    delete m_tasks.at(row);
    m_tasks.removeAt(row);
    endRemoveRows();
}

Task* TaskModel::getTask(int row) const
{
    if (row < 0 || row >= m_tasks.size())
        return nullptr;
    return m_tasks.at(row);
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

