from flask import Flas

app = Flask(__name__)
@app.route('/')

def hello_world():
    return 'Hello, Docker!'