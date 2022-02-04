from elasticsearch import Elasticsearch
from flask import Flask
from config import Config
from flask_sqlalchemy import SQLAlchemy

es = Elasticsearch()
app = Flask(__name__)
app.config.from_object(Config)
db = SQLAlchemy(app)
from app import views