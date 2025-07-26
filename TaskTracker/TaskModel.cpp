#include "TaskModel.h"

TaskModel::TaskModel(QObject *parent)
    : QAbstractListModel(parent)
{}


TaskModel::~TaskModel()
{
    qDeleteAll(m_tasks);
    m_tasks.clear();
}
