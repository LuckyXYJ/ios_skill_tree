#include "mainwindow.h"

#include <QApplication>

#include <iostream>

#include <QDebug>

extern "C" {
#include<libavdevice/avdevice.h>

}

int main(int argc, char *argv[])
{
    avdevice_register_all();

    QApplication a(argc, argv);
    MainWindow w;
    w.show();
    return a.exec();
}
