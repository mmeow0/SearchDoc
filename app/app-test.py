import os

import elasticsearch
from elasticsearch import Elasticsearch
from app import app
import unittest


class BasicTestCase(unittest.TestCase):

  def test_index(self):
      tester = app.test_client(self)
      response = tester.get('/', content_type='html/text')
      self.assertEqual(response.status_code, 200)

  def test_esdata_imported(self):
      tester = os.path.exists("esdata")
      self.assertTrue(tester)


class FlaskrTestCase(unittest.TestCase):
    def search(self, text):
        """Вспомогательная функция поиска по полю text"""
        return app.elasticsearch.search(
        index="posts",
        body={"query": {
            "multi_match": {
                "query": text,
                "fields": ["text"]}},
            'size': 20}
    )

    def delete(self, id):
        """Вспомогательная функция удаления записи по Id"""
        return app.elasticsearch.delete(index="posts", doc_type='_doc', id=id)


    # Функции с утверждениями (assert)

    def test_search(self):
        """Протестируем что поиск работает"""
        tester=self.search("привет")
        assert "привет" in tester['hits']['hits'][0]["_source"]["text"]

    def test_delete(self):
        """Протестируем что записи удаляются"""
        try:
            tester = self.delete("XOjo2H4BSKBUOpJAEF7U")
        except elasticsearch.exceptions.NotFoundError:
            tester= "not_found"
        assert 'deleted' in tester or 'not_found' in tester


if __name__ == '__main__':
  unittest.main()