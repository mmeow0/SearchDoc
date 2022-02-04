#!/bin/bash
app="docker.test"
localaddr=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
docker build -t ${app} .
docker run -d -p 56743:80 -p 9200:9200 \
  --name=${app} -e ES_HOST=${localaddr} \
  -v $PWD:/app ${app}
if lsof -Pi :9200 -sTCP:LISTEN -t >/dev/nul; then
   echo "elasticsearch уже работает, либо что-то еще заняло порт!"
else
   echo "Запуск elasticsearch"
   elasticsearch
fi