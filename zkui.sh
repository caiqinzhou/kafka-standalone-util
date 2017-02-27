#!/bin/bash

set -eu

set +e
echo "Stop kafka zkui..."
docker stop kafka-zkui
docker rm -f kafka-zkui
set -e

echo "Start kafka zkui..."
docker run -d --name kafka-zkui --rm --net=host -e ZKUI_ZK_SERVER=localhost:2181 qnib/zkui

echo "Done!"

echo "GO： http://localhost:9090"
echo "User: admin"
echo "Password: admin"
