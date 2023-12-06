import unittest
from app import app


"""
Tests that the HTTP packet recieved is OK status code 200.

"""


class AppTestCase(unittest.TestCase):
    def test_index(self):
        tester = app.test_client(self)
        response = tester.get("/", content_type="html/text")
        self.assertEqual(response.status_code, 200)

        # Test to see if will build!
        # self.assertEqual(response.data, b"Hello World!")

    def test_default(self):
        tester = app.test_client(self)
        response = tester.get("xyz", content_type="html/text")
        self.assertEqual(response.status_code, 404)
        self.assertTrue(b"does not exist" in response.data)


if __name__ == "__main__":
    unittest.main()
