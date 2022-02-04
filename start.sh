#!/bin/bash
app="searchapp"
localaddr=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
docker network create elastic-net
docker pull docker.elastic.co/elasticsearch/elasticsearch:7.17.0
docker run -d -p 127.0.0.1:9200:9200 \
 -p 127.0.0.1:9300:9300 \
 --name elasticsearch \
  -e "discovery.type=single-node" \
  --net elastic-net docker.elastic.co/elasticsearch/elasticsearch:7.17.0

docker build -t ${app} .
docker run -d -p 56743:80 \
  --net elastic-net \
  --name=${app} -e ES_HOST=${localaddr} \
  -v $PWD:/app ${app}
