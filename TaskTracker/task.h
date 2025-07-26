#ifndef TASK_H
#define TASK_H


#include <QObject>
#include <QString>
#include <QDateTime>
#include <QDebug>

class Task: public QObject
{

    Q_OBJECT

    Q_PROPERTY(int id READ getId WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString name READ getName WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString description READ getDescription WRITE setDescription NOTIFY descriptionChanged)
    Q_PROPERTY(QDateTime dueDate READ getDueDate WRITE setDueDate NOTIFY dueDateChanged)
    Q_PROPERTY(bool isCompleted READ isCompleted WRITE setIsCompleted NOTIFY isCompletedChanged)
    Q_PROPERTY(int priority READ getPriority WRITE setPriority NOTIFY priorityChanged)
    Q_PROPERTY(QDateTime createdAt READ getCreatedAt WRITE setCreatedAt NOTIFY createdAtChanged)
    Q_PROPERTY(QDateTime updatedAt READ getUpdatedAt WRITE setUpdatedAt NOTIFY updatedAtChanged)

public:
    explicit Task(QObject *parent =nullptr);
    Task(const QString &name,QObject *parent=nullptr);
    Task(const Task &other);
    virtual ~Task();

    int getId() const;
    QString getName() const;
    QString getDescription() const;
    QDateTime getDueDate() const;
    bool isCompleted() const;
    int getPriority() const;
    QDateTime getCreatedAt() const;
    QDateTime getUpdatedAt() const;


    void setId(int id);
    void setName(const QString &name);
    void setDescription(const QString &description);
    void setDueDate(const QDateTime &dueDate);
    void setIsCompleted(bool isCompleted);
    void setPriority(int priority);
    void setCreatedAt(const QDateTime &createdAt);
    void setUpdatedAt(const QDateTime &updatedAt);

    // Методы
    bool isOverdue() const;
    QString toString() const; // debug method
    bool isValid() const;



signals:
    void idChanged();
    void nameChanged();
    void descriptionChanged();
    void dueDateChanged();
    void isCompletedChanged();
    void priorityChanged();
    void createdAtChanged();
    void updatedAtChanged();

private:

    int m_id;
    QString m_name;
    QString m_description;
    QDateTime m_dueDate;
    bool m_isCompleted;
    int m_priority;
    QDateTime m_createdAt;
    QDateTime m_updatedAt;


};

#endif // TASK_H
