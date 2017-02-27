#!/bin/bash

set -eu

set +e
echo "Stop kafka manager..."
docker stop kafka-manager
docker rm -f kafka-manager
set -e

echo "Start kafka manager..."
docker run -d --name=kafka-manager --rm --net=host -e ZK_HOSTS="localhost:2181" sheepkiller/kafka-manager


echo "Done!"

echo "GO： http://localhost:9000"

