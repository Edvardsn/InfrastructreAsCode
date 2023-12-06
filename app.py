import json
from flask import Flask
import psycopg2
import os

app = Flask(__name__)


@app.route("/")
def hello_world():
    return "<h1>This is a webserver built with a Continous deployment pipeline!<h1>"


@app.route("/")
def default(page):
    response = make_response("The page %s does not exist." % page, 404)

    return response


print("Webserver listening on port: ", os.environ["WEBSERVER_PORT"])
print("-----------------------------------")

# Starts the server on localhost with port 80 as a default
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("WEBSERVER_PORT", 5000)))
