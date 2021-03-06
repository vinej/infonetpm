# project/server/models.py

import jwt
import datetime
from bson.objectid import ObjectId
from InfoNetPm.project.server import app, bcrypt, mongo


class BlacklistToken:
    """
        Token Model for storing JWT tokens
        """
    id = ''
    token = ''
    blacklisted_on = ''
    
    def __init__(self, m_id, token, blacklisted_on):
        self.id = m_id
        self.token = token
        self.blacklisted_on = blacklisted_on
    
    def __repr__(self):
        return '<id: token: {}'.format(self.token)
    
    @staticmethod
    def check_blacklist(auth_token):
        # check whether auth token has been blacklisted
        blacklist = mongo.db.blacklists.find_one({'token': {'$eq': str(auth_token)}})
        if blacklist:
            return True
        else:
            return False

    @staticmethod
    def post_blacklist(auth_token):
        # check whether auth token has been blacklisted
        try:
            d = dict(token=str(auth_token), blacklisted__on=datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
            mongo_id = mongo.db.blacklists.insert(d)
            mongo_bl = mongo.db.blacklists.find_one({'_id': mongo_id})
            if mongo_bl:
                blacklist = BlacklistToken(str(mongo_bl['_id']), mongo_bl['token'], mongo_bl['blacklisted__on'])
                return blacklist
            else:
                return None
        except Exception as inst:
            print(inst)
            raise


class User:
    """ User Model for storing user related details """
    __tablename__ = "users"
    
    id = ''
    email = ''
    password = ''
    registered_on = ''
    admin = ''
    
    @staticmethod
    def get_user(email):
        mongo_user = mongo.db.users.find_one({'email': {'$eq': email}})
        if mongo_user:
            user = User(str(mongo_user['_id']), mongo_user['email'], mongo_user['password'])
            return user
        else:
            return None

    @staticmethod
    def get_user_by_id(m_id):
        mongo_user = mongo.db.users.find_one({'_id': {'$eq': ObjectId(m_id)}})
        if mongo_user:
            user = User(str(mongo_user['_id']), mongo_user['email'], mongo_user['password'], mongo_user['admin'])
            return user
        else:
            return None

    @staticmethod
    def post_user(email, password, admin):
        try:
            d = dict(email=email,
                     password=password,
                     admin=admin,
                     register_on=datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
            mongo_id = mongo.db.users.insert(d)
            mongo_user = mongo.db.users.find_one({'_id': mongo_id})
            if mongo_user:
                user = User(str(mongo_user['_id']), mongo_user['email'], mongo_user['password'], mongo_user['admin'])
                return user
            else:
                return None
        except Exception as inst:
            print(inst)
            raise

    @staticmethod
    def put_user(json):
        old = mongo.db.users.find_one({'id': json["_id"]})
        mongo.db.users.replace_one(old, json)
    
    def __init__(self, m_id, email, password, admin=False):
        self.id = m_id
        self.email = email
        self.password = bcrypt.generate_password_hash(
          password, app.config.get('BCRYPT_LOG_ROUNDS')
          ).decode()
        self.registered_on = datetime.datetime.now()
        self.admin = admin

    @staticmethod
    def encode_auth_token(user_id):
        """
        Generates the Auth Token
        return: string
        """
        try:
            payload = {
                'exp': datetime.datetime.utcnow() + datetime.timedelta(days=0, seconds=5),
                'iat': datetime.datetime.utcnow(),
                'sub': user_id
            }
            return jwt.encode(payload, app.config.get('SECRET_KEY'), algorithm='HS256')
        except Exception as e:
            return e

    @staticmethod
    def decode_auth_token(auth_token):
        """
        Validates the auth token
        :param auth_token:
        :return: integer|string
        """
        try:
            payload = jwt.decode(auth_token, app.config.get('SECRET_KEY'))
            is_blacklisted_token = BlacklistToken.check_blacklist(auth_token)
            if is_blacklisted_token:
                return 'BadToken: blacklisted. Please log in again.'
            else:
                return payload['sub']
        except jwt.ExpiredSignatureError:
            return 'BadToken: Signature expired. Please log in again.'
        except jwt.InvalidTokenError:
            return 'BadToken: Invalid token. Please log in again.'
