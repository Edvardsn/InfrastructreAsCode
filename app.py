import json
from flask import Flask
import psycopg2
import os

app = Flask(__name__)


@app.route("/")
def hello_world():
    return "This is built with Continous deployment"


print("Webserver listening on port: ", os.environ["WEBSERVER_PORT"])
print("-----------------------------------")

# Starts the server on localhost with port 80 as a default
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("WEBSERVER_PORT", 5000)))
