FROM tiangolo/uwsgi-nginx-flask:python3.6-alpine3.7
RUN apk --update add bash nano curl
ENV STATIC_URL /static
ENV STATIC_PATH /var/www/app/static
ARG ELASTICSEARCH_URL=http://localhost:9200
ENV ELASTICSEARCH_URL=${ELASTICSEARCH_URL}
COPY ./requirements.txt /var/www/requirements.txt
RUN pip install --upgrade pip
RUN pip install -r /var/www/requirements.txt
