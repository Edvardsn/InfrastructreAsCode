import json
from flask import Flask
import psycopg2
import os

app = Flask(__name__)

# # Varaibles for the database connection used for Development
# db_name = os.environ["DB_NAME"]
# db_host = os.environ["DB_HOST"]
# db_port = os.environ["DB_PORT"]
# db_user = os.environ["DB_USER"]
# db_password = os.environ["DB_PASSWORD"]


@app.route("/")
def hello_world():
    return "Hello CI/CD"


# @app.route("/widgets")
# def get_widgets():
#     with psycopg2.connect(
#         host=db_host,
#         user=db_user,
#         password=db_password,
#         database=db_name,
#         port=db_port,
#     ) as conn:
#         with conn.cursor() as cur:
#             cur.execute("SELECT * FROM widgets")
#             row_headers = [x[0] for x in cur.description]
#             results = cur.fetchall()
#     conn.close()

#     json_data = [dict(zip(row_headers, result)) for result in results]
#     return json.dumps(json_data)


# @app.route("/initdb")
# def db_init():
#     conn = psycopg2.connect(
#         host=db_host, user=db_user, password=db_password, database=db_name, port=db_port
#     )
#     conn.set_session(autocommit=True)
#     with conn.cursor() as cur:
#         cur.execute("DROP DATABASE IF EXISTS example")
#         cur.execute("CREATE DATABASE example")
#     conn.close()

#     with psycopg2.connect(
#         host=db_host, user=db_user, password=db_password, database=db_name, port=db_port
#     ) as conn:
#         with conn.cursor() as cur:
#             cur.execute("DROP TABLE IF EXISTS widgets")
#             cur.execute(
#                 "CREATE TABLE widgets (name VARCHAR(255), description VARCHAR(255))"
#             )
#     conn.close()

#     return "init database"


# # Debugging info
# print("Database properties: ", db_name, db_host, db_port)
# print("-----------------------------------")
print("Webserver listening on port: ", os.environ["WEBSERVER_PORT"])
print("-----------------------------------")

# Starts the server on localhost with port 80 as a default
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("WEBSERVER_PORT", 5000)))
