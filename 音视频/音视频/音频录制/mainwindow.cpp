#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <QDebug>
#include <QFile>
#include <QThread>

extern "C" {
// 设备
#include <libavdevice/avdevice.h>
// 格式
#include <libavformat/avformat.h>
// 工具
#include <libavutil/avutil.h>
#include <libavcodec/avcodec.h>
}

#ifdef Q_OS_WIN
    #define FMT_NAME "dshow"
    #define DEVICE_NAME "audio=..."
    // pcm文件名
    #define FILE_NAME "/Users/xyj/Private/Result/code/AudioVideo/file/test.pcm"
#else
    #define FMT_NAME "avfoundation"
    #define DEVICE_NAME ":0"
    #define FILE_NAME "/Users/xyj/Private/Result/code/AudioVideo/file/test.pcm"
#endif

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    delete ui;
}


void MainWindow::on_audioButton_clicked()
{    
    if (!_audioThread) { // 点击了“开始录音”
        // 开启线程
        _audioThread = new audiothread();
//        _audioThread = new audiothread(this);
        _audioThread->start();

        connect(_audioThread, &audiothread::finished,
        [this]() { // 线程结束
            _audioThread = nullptr;
            ui->audioButton->setText("开始录音");
        });

        // 设置按钮文字
        ui->audioButton->setText("结束录音");
    } else { // 点击了“结束录音”
        // 结束线程
//        _audioThread->setStop(true);
        _audioThread->requestInterruption();
        _audioThread = nullptr;

        // 设置按钮文字
        ui->audioButton->setText("开始录音");
    }
}

