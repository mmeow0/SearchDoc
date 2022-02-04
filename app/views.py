from flask import render_template
from app import app
from config import Config


@app.route('/')
def home():
   return str(Config.ELASTICSEARCH_URL)

@app.route('/template')
def template():
    return render_template('home.html')
