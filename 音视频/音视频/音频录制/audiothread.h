#ifndef AUDIOTHREAD_H
#define AUDIOTHREAD_H

#include <QThread>

class audiothread : public QThread
{
    Q_OBJECT
private:
    void run();
    bool _stop = false;

public:
    explicit audiothread(QThread *parent = nullptr);
    ~audiothread();
    void setStop(bool stop);
signals:

};

#endif // AUDIOTHREAD_H
