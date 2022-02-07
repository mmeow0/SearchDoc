#!/bin/bash
app="searchapp"
esApp="elasticsearch"
logstashApp="logstash"

export SEARCHDOC_DIR=$(pwd)
localaddr=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')

docker network create elastic-net

docker pull docker.elastic.co/elasticsearch/elasticsearch:7.17.0
docker run -d -p 127.0.0.1:9200:9200 \
 -p 127.0.0.1:9300:9300 \
 --name $esApp \
 -v "/$(pwd)/esdata":/usr/share/elasticsearch/data \
 -v "/$(pwd)/config/elasticsearch.yml":/etc/elasticsearch/elasticsearch.yml \
 -e "bootstrap.memory_lock=true" \
 -e "discovery.type=single-node" \
 -e "ES_JAVA_OPTS=-Xms512m -Xmx512m" \
 --net elastic-net docker.elastic.co/elasticsearch/elasticsearch:7.17.0


docker build -t ${app} .
docker run -d -p 56743:80 \
  --net elastic-net \
  --name=${app} -e ES_HOST=${esApp} \
  -v $PWD:/app ${app}

# -v $(pwd)/config/pipelines/:/usr/share/logstash/config/pipelines/ \
# -v $(pwd)/config/pipelines.yml:/usr/share/logstash/config/pipelines.yml \

docker pull docker.elastic.co/logstash/logstash:7.17.0
docker run --rm -d \
 -v "/$(pwd)/config/logstash.conf":/usr/share/logstash/config/logstash.conf \
 -v "/$(pwd)/posts.csv":/usr/share/logstash/posts.csv \
 -v "/$(pwd)/config/pipelines.yml":/usr/share/logstash/config/pipelines.yml \
 --name $logstashApp -p 5046:5046 \
 --net elastic-net \
 docker.elastic.co/logstash/logstash:7.17.0

