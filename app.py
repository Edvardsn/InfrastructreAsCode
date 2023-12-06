from flask import Flask
from flask import make_response

app = Flask(__name__)


@app.route("/")
def hello_world():
    return "This is a webserver built with a Continous Deployment pipeline!"


@app.route("/")
def default(page):
    response = make_response("The page %s does not exist." % page, 404)

    return response


# Starts the server on localhost with port 80 as a default
if __name__ == "__main__":
    app.run(
        host="0.0.0.0", port=int(os.environ.get("WEBSERVER_PORT", 5000)), debug=True
    )
