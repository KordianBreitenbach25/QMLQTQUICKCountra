#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QtQml>
class Backend : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit Backend(QObject *parent = nullptr);
    Q_INVOKABLE void generateNumber(int min,int max);
signals:
    void numberEmitted(int num,int nums);
};

#endif // BACKEND_H
