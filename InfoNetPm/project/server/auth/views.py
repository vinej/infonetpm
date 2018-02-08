# project/server/auth/views.py


from flask import Blueprint, request, make_response, jsonify
from flask.views import MethodView
from project.server import bcrypt

from project.server.models import User, BlacklistToken

auth_blueprint = Blueprint('auth', __name__)


def is_bad_token(resp):
    return resp[0:9] == "BadToken:"


class RegisterAPI(MethodView):
    """
        User Registration Resource
        """
    
    def post(self):
        # get the post data
        post_data = request.get_json()
        # check if user already exists
        user = User.get_user(post_data.get('email'))
        if not user:
            try:
                # insert the user
                user = User.post_user(post_data.get('email'), post_data.get('password'), True)
                # generate the auth token
                auth_token = User.encode_auth_token(user.id)
                response_object = {
                    'status': 'success',
                    'message': 'Successfully registered.',
                    'auth_token': auth_token.decode()
                }
                return make_response(jsonify(response_object)), 201
            except Exception as e:
                response_object = {
                    'status': 'fail',
                    'message': 'Some error occurred. Please try again.'
                }
                return make_response(jsonify(response_object)), 401
        else:
            response_object = {
                'status': 'fail',
                'message': 'User already exists. Please Log in.',
            }
            return make_response(jsonify(response_object)), 202


class LoginAPI(MethodView):
    """
        User Login Resource
        """
    def post(self):
        # get the post data
        post_data = request.get_json()
        try:
            # fetch the user data
            user = User.get_user(post_data.get('email'))
            if user and bcrypt.check_password_hash(user.password, post_data.get('password')):
                auth_token = User.encode_auth_token(user.id)
                if auth_token:
                    response_object = {
                        'status': 'success',
                        'message': 'Successfully logged in.',
                        'auth_token': auth_token.decode()
                    }
                    return make_response(jsonify(response_object)), 200
            else:
                response_object = {
                    'status': 'fail',
                    'message': 'User does not exist.'
                }
                return make_response(jsonify(response_object)), 404
        except Exception as e:
            print(e)
            response_object = {
                'status': 'fail',
                'message': 'Try again'
            }
            return make_response(jsonify(response_object)), 500


class UserAPI(MethodView):
    """
        User Resource
        """
    def get(self):
        # get the auth token
        auth_header = request.headers.get('Authorization')
        if auth_header:
            try:
                auth_token = auth_header.split(" ")[1]
            except IndexError:
                response_object = {
                    'status': 'fail',
                    'message': 'Bearer token malformed.'
                }
                return make_response(jsonify(response_object)), 401
        else:
            auth_token = ''
    
        if auth_token:
            resp = User.decode_auth_token(auth_token)
            if not is_bad_token(resp):
                user = User.get_user_by_id(resp)
                response_object = {
                    'status': 'success',
                    'data': {
                        'user_id': user.id,
                        'email': user.email,
                        'admin': user.admin,
                        'registered_on': user.registered_on
                }
                }
                return make_response(jsonify(response_object)), 200
            else:
                response_object = {
                    'status': 'fail',
                    'message': resp
                }
                return make_response(jsonify(response_object)), 401
else:
    response_object = {
        'status': 'fail',
            'message': 'Provide a valid auth token.'
            }
            return make_response(jsonify(response_object)), 401


class LogoutAPI(MethodView):
    """
        Logout Resource
        """
    def post(self):
        # get auth token
        auth_header = request.headers.get('Authorization')
        if auth_header:
            auth_token = auth_header.split(" ")[1]
        else:
            auth_token = ''
        if auth_token:
            resp = User.decode_auth_token(auth_token)
            if not is_bad_token(resp):
                try:
                    # insert the token
                    blacklist_token = BlacklistToken.post_blacklist(auth_token)
                    response_object = {
                        'status': 'success',
                        'message': 'Successfully logged out.'
                    }
                    return make_response(jsonify(response_object)), 200
                except Exception as e:
                    response_object = {
                        'status': 'fail',
                        'message': e
                    }
                    return make_response(jsonify(response_object)), 200
            else:
                response_object = {
                    'status': 'fail',
                    'message': resp
                }
                return make_response(jsonify(response_object)), 401
        else:
            response_object = {
                'status': 'fail',
                'message': 'Provide a valid auth token.'
            }
            return make_response(jsonify(response_object)), 403
# define the API resources


registration_view = RegisterAPI.as_view('register_api')
login_view = LoginAPI.as_view('login_api')
user_view = UserAPI.as_view('user_api')
logout_view = LogoutAPI.as_view('logout_api')

# add Rules for API Endpoints
auth_blueprint.add_url_rule(
                            '/auth/register',
                            view_func=registration_view,
                            methods=['POST']
                            )
auth_blueprint.add_url_rule(
                            '/auth/login',
                            view_func=login_view,
                            methods=['POST']
                            )
auth_blueprint.add_url_rule(
                            '/auth/status',
                            view_func=user_view,
                            methods=['GET']
                            )
auth_blueprint.add_url_rule(
                            '/auth/logout',
                            view_func=logout_view,
                            methods=['POST']
                            )


