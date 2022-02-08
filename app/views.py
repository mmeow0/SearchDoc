from flask import render_template, request
from app import app



@app.route('/')
def home():
    return render_template("home.html")


@app.route("/search", methods=['POST'])
def search_es():
    if request.method == 'POST':
        query = request.form['search']
    data = app.elasticsearch.search(
        index="posts",
        body={"query": {
            "multi_match": {
                "query": query,
                "fields": ["text"]}},
            'size': 20}
    )
    posts = [{"id": data["_id"],
              "text": data["_source"]["text"],
              "rubrics": data["_source"]["rubrics"],
              "created_date": data["_source"]["created_date"]}
             for data in data['hits']['hits']]
    posts.sort(key=lambda item:item['created_date'])
    if not posts:
        info="По вашему запросу ничего не найдено"

    return render_template("index.html", data=posts, info=info)


@app.route("/delete", methods=['POST'])
def delete_es():
    if request.method == 'POST':
        id = request.form['delete']
    res = app.elasticsearch.delete(index="posts", doc_type='_doc', id=id)
    if "result" in res and res["result"] == "deleted":
        res="Post deleted"
    else:
        res = "Error while deleting"
    return render_template("delete.html", data=res)

