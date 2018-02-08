# InfonetPm/project/server/__init__.py

import os
from flask import Flask
from flask_bcrypt import Bcrypt
from flask_cors import CORS
from flask_pymongo import PyMongo


app = Flask(__name__)
CORS(app)

app_settings = os.getenv(
    'APP_SETTINGS',
    'project.server.config.DevelopmentConfig'
)
app.config.from_object(app_settings)

app.config['MONGO_DBNAME'] = 'restdb'
app.config['MONGO_URI'] = 'mongodb://localhost:27017/restdb'

mongo = PyMongo(app)

bcrypt = Bcrypt(app)

from InfoNetPm.project.server.auth.views import auth_blueprint
app.register_blueprint(auth_blueprint)

import InfoNetPm.project.server.services.infonetpm
