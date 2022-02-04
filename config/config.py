import os


class Config(object):
    ES_PORT=9200
    ES_HOST = os.environ.get('ES_HOST')
    ELASTICSEARCH_URL = 'http://{}:{}'.format(ES_HOST, ES_PORT)
