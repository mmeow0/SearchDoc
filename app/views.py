from flask import render_template
from app import app
from app.settings import ELASTICSEARCH_URL


@app.route('/')
def home():
   return str(ELASTICSEARCH_URL)

@app.route('/template')
def template():
    return render_template('home.html')
