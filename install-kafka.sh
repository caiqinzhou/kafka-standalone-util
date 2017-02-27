#!/bin/bash
set -eu

KAFKA_VERSION="kafka_2.11-0.10.2.0"
if [ ! -f "$KAFKA_VERSION.tgz" ]
then
    echo "Download kafka package..."
    rm -rf $KAFKA_VERSION
    wget "http://mirrors.hust.edu.cn/apache/kafka/0.10.2.0/kafka_2.11-0.10.2.0.tgz"
fi

if [ ! -d $KAFKA_VERSION ]
then
    echo "Extract package..."
    tar -xzf $KAFKA_VERSION.tgz
fi

cd $KAFKA_VERSION

function kill_pidfile()
{
    PID_FILE=$1
    if [ -f $PID_FILE ]
    then
        echo "Kill pid file: $PID_FILE($(cat $PID_FILE))"
        set +e
        kill -9 $(cat $PID_FILE)
        sleep 3
        set -e
    fi
    rm -rf $PID_FILE
}

echo "Stop zookeeper..."
kill_pidfile zookeeper.pid

echo "Start zookeeper..."
nohup ./bin/zookeeper-server-start.sh config/zookeeper.properties 1>zookeeper.log 2>&1 &
ZOOKEEPER_PID="$!"
echo "Zookeeper: $ZOOKEEPER_PID"
echo "$ZOOKEEPER_PID" > zookeeper.pid


echo "Stop kafka..."
kill_pidfile kafka.pid

echo "Start kafka server..."
nohup ./bin/kafka-server-start.sh config/server.properties 1>kafka.log 2>&1 &
KAFKA_PID="$!"
echo "Kafka: $KAFKA_PID"
echo "$KAFKA_PID" > kafka.pid

echo "Done!"
