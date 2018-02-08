# project/tests/base.py
from flask_testing import TestCase
from InfoNetPm.project.server import app, mongo


class BaseTestCase(TestCase):
    """ Base Tests """

    def create_app(self):
        app.config.from_object('project.server.config.TestingConfig')
        return app

    def setUp(self):
        pass

    def tearDown(self):
        pass
        #mongo.db.users.drop()
        #mongo.db.blacklists.drop()
