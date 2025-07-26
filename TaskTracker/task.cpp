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
