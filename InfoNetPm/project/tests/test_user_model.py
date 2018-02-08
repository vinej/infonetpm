# project/tests/test_user_model.py
import unittest
from InfoNetPm.project.server.models import User
from InfoNetPm.project.tests.base import BaseTestCase


class TestUserModel(BaseTestCase):

    ID = '123456'

    def test_encode_auth_token(self):
        user = User(m_id='123456', email='test@test.com', password='test')
        auth_token = user.encode_auth_token(user.id)
        self.assertTrue(isinstance(auth_token, bytes))

    def test_decode_auth_token(self):
        user = User(
            m_id='123456',
            email='test@test.com',
            password='test'
        )
        auth_token = user.encode_auth_token(user.id)
        self.assertTrue(isinstance(auth_token, bytes))

        self.assertTrue(User.decode_auth_token(
            auth_token.decode("utf-8")) == '123456')


if __name__ == '__main__':
    unittest.main()
