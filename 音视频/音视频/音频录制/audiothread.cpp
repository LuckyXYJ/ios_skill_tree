#include "audiothread.h"

#include <QFile>
#include <QDateTime>
#include <QThread>
#include <QDebug>
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
    #define FILEPATH "/Users/xyj/Private/Result/code/AudioVideo/file/"
#endif

audiothread::audiothread(QThread *parent)
    : QThread{parent}
{
    // 当监听到线程结束时（finished），就调用deleteLater回收内存
        connect(this, &audiothread::finished,
                this, &audiothread::deleteLater);
}

void showSpec(AVFormatContext *ctx) {
    // 获取输入流
    AVStream *stream = ctx->streams[0];
    // 获取音频参数
    AVCodecParameters *params = stream->codecpar;
    // 声道数
    qDebug() << params->channels;
    // 采样率
    qDebug() << params->sample_rate;
    // 采样格式
    qDebug() << params->format;
    // 每一个样本的一个声道占用多少个字节
    qDebug() << av_get_bytes_per_sample((AVSampleFormat) params->format);
}

void audiothread::run() {

    // 获取输入格式对象
    const AVInputFormat *fmt = av_find_input_format(FMT_NAME);

    if(!fmt) {
        qDebug() << "获取输入设备格式失败";
        return;
    }

    // 打开设备
    AVFormatContext *ctx = nullptr;
    qDebug() << "打开设备尝试";
//    AVDictionary *options = nullptr;
//    int ret = avformat_open_input(&ctx, deviceName, fmt, &options);
//    int ret = avformat_open_input(&ctx, deviceName, fmt, nullptr);

    int ret = avformat_open_input(&ctx, DEVICE_NAME, fmt, nullptr);

    if (ret < 0) {
        char errbuf[1024] = {0};
        // 根据函数返回的错误码获取错误信息
        av_strerror(ret, errbuf, sizeof (errbuf));
        qDebug() << "打开设备失败" << errbuf;
        return;
    }

    qDebug() << "打开设备成功";

    // 打印一下录音设备的参数信息
    showSpec(ctx);

    // 文件名
    QString filename = FILEPATH;

    filename += QDateTime::currentDateTime().toString("MM_dd_HH_mm_ss");
    filename += ".pcm";
    QFile file(filename);
    // 如果文件不存在，创建文件，如果文件存在，清空文件内容
    if(!file.open(QIODevice::WriteOnly)){
//        qDebug() << "文件打开失败" << fileName;
        // 关闭设备
        avformat_close_input(&ctx);
        return;
    };

    // 采集的次数
    int count = 50;

    // 数据包
    AVPacket *pkt = av_packet_alloc();
//    AVPacket pkt;

    // 采集数据
    while(!isInterruptionRequested()) {
        ret = av_read_frame(ctx, pkt);
//        ret = av_read_frame(ctx, &pkt);
        if (ret == 0) {
            // 将数据写入文件
//            file.write((const char *)pkt.data, pkt.size);
            file.write((const char *)pkt->data, pkt->size);
            qDebug() << "写入数据" << ret;
        }else if (ret == AVERROR(EAGAIN)) { // 资源临时不可用
            qDebug() << "资源临时不可用" << ret;
            continue;
        } else {
            char errbuf[1024] = {0};
            // 根据函数返回的错误码获取错误信息
            av_strerror(ret, errbuf, sizeof (errbuf));
            qDebug() << "录制失败" << errbuf << ret;
            break;
        }

        // 必须要加，释放pkt内部的资源
//        av_packet_unref(&pkt);
        av_packet_unref(pkt);
    }

    qDebug() << pkt->size;

    // 释放资源
    // 关闭文件
    file.close();

    // 释放资源
    av_packet_free(&pkt);

    // 关闭设备
    avformat_close_input(&ctx);
}


audiothread::~audiothread()
{
    // 断开所有的连接
    disconnect();
    // 内存回收之前，正常结束线程
    requestInterruption();
    // 安全退出
    quit();
    wait();
//    qDebug() << this << "析构（内存被回收）";
}
