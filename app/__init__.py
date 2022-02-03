from elasticsearch import Elasticsearch
from flask import Flask
es = Elasticsearch()
app = Flask(__name__)
from app import views