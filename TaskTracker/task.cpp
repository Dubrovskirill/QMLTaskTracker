#include "task.h"
#include "qdebug.h"

Task::Task(QObject *parent)

    : QObject(parent),
    m_id(0),
    m_name(""),
    m_description(""),
    m_dueDate(QDateTime()),
    m_isCompleted(false),
    m_priority(2),
    m_createdAt(QDateTime::currentDateTime()),
    m_updatedAt(QDateTime::currentDateTime())
{}

Task::Task(const QString &name, QObject *parent)
   : QObject(parent),
    m_id(0),
    m_name(name),
    m_description(""),
    m_dueDate(QDateTime()),
    m_isCompleted(false),
    m_priority(2),
    m_createdAt(QDateTime::currentDateTime()),
    m_updatedAt(QDateTime::currentDateTime())
{}

Task::Task(const Task &other)
    : QObject(other.parent()),
    m_id(other.m_id),
    m_name(other.m_name),
    m_description(other.m_description),
    m_dueDate(other.m_dueDate),
    m_isCompleted(other.m_isCompleted),
    m_priority(other.m_priority),
    m_createdAt(other.m_createdAt),
    m_updatedAt(other.m_updatedAt)
{}

Task::~Task()
{
    qDebug() << "Task destroyed:" << m_name;
}


int Task::getId() const
{
    return m_id;
}

QString Task::getName() const
{
    return m_name;
}

QString Task::getDescription() const
{
    return m_description;
}

QDateTime Task::getDueDate() const
{
    return m_dueDate;
}

bool Task::isCompleted() const
{
    return m_isCompleted;
}

int Task::getPriority() const
{
    return m_priority;
}

QDateTime Task::getCreatedAt() const
{
    return m_createdAt;
}

QDateTime Task::getUpdatedAt() const
{
    return m_updatedAt;
}

// Сеттеры
void Task::setId(int id)
{
    if (m_id != id) {
        m_id = id;
        emit idChanged();
    }
}

void Task::setName(const QString &name)
{
    if (m_name != name) {
        m_name = name;
        emit nameChanged();
    }
}

void Task::setDescription(const QString &description)
{
    if (m_description != description) {
        m_description = description;
        emit descriptionChanged();
    }
}

void Task::setDueDate(const QDateTime &dueDate)
{
    if (m_dueDate != dueDate) {
        m_dueDate = dueDate;
        emit dueDateChanged();
    }
}

void Task::setIsCompleted(bool isCompleted)
{
    if (m_isCompleted != isCompleted) {
        m_isCompleted = isCompleted;
        emit isCompletedChanged();
    }
}

void Task::setPriority(int priority)
{
    if (m_priority != priority) {
        m_priority = priority;
        emit priorityChanged();
    }
}

void Task::setCreatedAt(const QDateTime &createdAt)
{
    if (m_createdAt != createdAt) {
        m_createdAt = createdAt;
        emit createdAtChanged();
    }
}

void Task::setUpdatedAt(const QDateTime &updatedAt)
{
    if (m_updatedAt != updatedAt) {
        m_updatedAt = updatedAt;
        emit updatedAtChanged();
    }
}

