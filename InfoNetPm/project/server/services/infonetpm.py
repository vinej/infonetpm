# mongo.py
from flask import Flask
from flask import jsonify
from flask import request
from project.server import app

# model less services for iOS

def date(datestr="", format="%Y-%m-%dT%H:%M:%S%z"):
  from datetime import datetime
  if not datestr:
    return datetime.today().date()
  return datetime.strptime(datestr, format).date()
#def

def get(documents, sdate) :
  #start = date(sdate)
  #print(start)
  output = []
  for d in documents.find({'updatedDate': {'$gte': sdate}}):
    d.pop('_id')
    output.append(d)
  #for
  print(output)
  return jsonify({'result' : output})
#def

def post(request, documents) :
  print(request.json)
  if (request.json is None):
    return
  #if
  request.json['isNew'] = False
  request.json['isSync'] = True
  mongo_id = documents.insert(request.json)
  output = documents.find_one({'_id': mongo_id })
  output.pop("_id")
  print(output)
  return jsonify({'result' : output})
#def

def put(request, documents) :
  print(request.json)
  request.json['isNew'] = False
  request.json['isSync'] = True
  old = documents.find_one({'id': json["id"] })
  output = documents.replace_one(old, request.json)
  print(output)
  return jsonify({'result' : output})
#def

@app.route('/auth/register', methods=['POST'])
def register():
	# get the post data
	post_data = request.get_json()
	# check if user already exists
	user = get_user(email)
	if not user:
		try:
			user_id = user_post(post_data.get('email'),post_data.get('password'),True)['_id']
			# generate the auth token
			auth_token = encode_auth_token(user_id)
			responseObject = {
				'status': 'success',
				'message': 'Successfully registered.',
				'auth_token': auth_token.decode()
			}
			return make_response(jsonify(responseObject)), 201
		except Exception as e:
			responseObject = {
				'status': 'fail',
				'message': 'Some error occurred. Please try again.'
			}
			return make_response(jsonify(responseObject)), 401
	else:
		responseObject = {
			'status': 'fail',
			'message': 'User already exists. Please Log in.',
		}
		return make_response(jsonify(responseObject)), 202
	#if
#def

@app.route('/auth/login', methods=['POST'])
def login():
	# get the post data
	post_data = request.get_json()
	try:
		# fetch the user data
		user = user_get(email)
		if user and bcrypt.check_password_hash(
			user['password'], post_data.get('password')
		):
			auth_token = encode_auth_token(user['_id'])
			if auth_token:
				responseObject = {
					'status': 'success',
					'message': 'Successfully logged in.',
					'auth_token': auth_token.decode()
				}
				return make_response(jsonify(responseObject)), 200
		else:
			responseObject = {
				'status': 'fail',
				'message': 'User does not exist.'
			}
			return make_response(jsonify(responseObject)), 404
	except Exception as e:
		print(e)
		responseObject = {
			'status': 'fail',
			'message': 'Try again'
		}
		return make_response(jsonify(responseObject)), 500
	#try
#def

'/auth/status'
@app.route('/auth/status', methods=['GET'])
def get(self):
	# get the auth token
	auth_header = request.headers.get('Authorization')
	if auth_header:
		try:
			auth_token = auth_header.split(" ")[1]
		except IndexError:
			responseObject = {
				'status': 'fail',
				'message': 'Bearer token malformed.'
			}
			return make_response(jsonify(responseObject)), 401
	else:
		auth_token = ''

	if auth_token:
		resp = decode_auth_token(auth_token)
		if not isinstance(resp, str):
			# fetch the user data
			user = user_get(email)
			responseObject = {
				'status': 'success',
				'data': {
					'user_id': user.id,
					'email': user.email,
					'admin': user.admin,
					'registered_on': user.registered_on
				}
			}
			return make_response(jsonify(responseObject)), 200
		responseObject = {
			'status': 'fail',
			'message': resp
		}
		return make_response(jsonify(responseObject)), 401
	else:
		responseObject = {
			'status': 'fail',
			'message': 'Provide a valid auth token.'
		}
		return make_response(jsonify(responseObject)), 401
	#if
#def

@app.route('/auth/logout', methods=['POST'])
def post(self):
	# get auth token
	auth_header = request.headers.get('Authorization')
	if auth_header:
		auth_token = auth_header.split(" ")[1]
	else:
		auth_token = ''
	if auth_token:
		resp = decode_auth_token(auth_token)
		if not isinstance(resp, str):
			# mark the token as blacklisted
			#blacklist_token = BlacklistToken(token=auth_token)
			try:
				# insert the token
				#db.session.add(blacklist_token)
				#db.session.commit()
				responseObject = {
					'status': 'success',
					'message': 'Successfully logged out.'
				}
				return make_response(jsonify(responseObject)), 200
			except Exception as e:
				responseObject = {
					'status': 'fail',
					'message': e
				}
				return make_response(jsonify(responseObject)), 200
		else:
			responseObject = {
				'status': 'fail',
				'message': resp
			}
			return make_response(jsonify(responseObject)), 401
	else:
		responseObject = {
			'status': 'fail',
			'message': 'Provide a valid auth token.'
		}
		return make_response(jsonify(responseObject)), 403
	#if
#def


@app.route('/company/<string:the_date>', methods=['GET'])
def get_company(the_date):
  return get(mongo.db.companies,the_date)
#def

@app.route('/company', methods=['POST'])
def add_company():
  return post(request,mongo.db.companies)
#def

@app.route('/company', methods=['PUT'])
def update_company():
  return put(request,mongo.db.companies)
#def

@app.route('/resource/<string:the_date>', methods=['GET'])
def get_resource(the_date):
  return get(mongo.db.resources,the_date)
#def

@app.route('/resource', methods=['POST'])
def add_resource():
  return post(request, mongo.db.resources)
#def

@app.route('/resource', methods=['PUT'])
def update_resource():
  return put(request, mongo.db.resources)
#def

@app.route('/activity/<string:the_date>', methods=['GET'])
def get_activity(the_date):
  return get(mongo.db.activities,the_date)
#def

@app.route('/activity', methods=['POST'])
def add_activity():
  return post(request, mongo.db.activities)
#def

@app.route('/activity', methods=['PUT'])
def update_activity():
  return put(request, mongo.db.activities)
#def

@app.route('/project/<string:the_date>', methods=['GET'])
def get_project(the_date):
  return get(mongo.db.project,the_date)
#def

@app.route('/project', methods=['POST'])
def add_project():
  return post(request, mongo.db.plans)
#def

@app.route('/project', methods=['PUT'])
def update_project():
  return put(request, mongo.db.project)
#def

@app.route('/plan/<string:the_date>', methods=['GET'])
def get_plan(the_date):
  return get(mongo.db.plans,the_date)
#def

@app.route('/plan', methods=['POST'])
def add_plan():
  return post(request, mongo.db.plans)
#def

@app.route('/plan', methods=['PUT'])
def update_plan():
  return put(request, mongo.db.plans)
#def

@app.route('/issue/<string:the_date>', methods=['GET'])
def get_issue(the_date):
  return get(mongo.db.issues,the_date)
#def

@app.route('/issue', methods=['POST'])
def add_issue():
  return post(request, mongo.db.issues)
#def

@app.route('/issue', methods=['PUT'])
def update_issue():
  return put(request, mongo.db.issues)
#def

@app.route('/role/<string:the_date>', methods=['GET'])
def get_role(the_date):
  return get(mongo.db.roles,the_date)
#def

@app.route('/role', methods=['POST'])
def add_role():
  return post(request, mongo.db.roles)
#def

@app.route('/role', methods=['PUT'])
def update_role():
  return put(request, mongo.db.roles)
#def

@app.route('/order/<string:the_date>', methods=['GET'])
def get_order(the_date):
  return get(mongo.db.orders,the_date)
#def

@app.route('/order', methods=['POST'])
def add_order():
  return post(request, mongo.db.orders)
#def

@app.route('/order', methods=['PUT'])
def update_order():
  return put(request, mongo.db.orders)
#def

@app.route('/status/<string:the_date>', methods=['GET'])
def get_status(the_date):
  return get(mongo.db.status,the_date)
#def

@app.route('/status', methods=['POST'])
def add_status():
  return post(request, mongo.db.status)
#def

@app.route('/status', methods=['PUT'])
def update_status():
  return put(request, mongo.db.status)
#def

@app.route('/document/<string:the_date>', methods=['GET'])
def get_document(the_date):
  return get(mongo.db.documents,the_date)
#def

@app.route('/document', methods=['POST'])
def add_document():
  return post(request, mongo.db.documents)
#def

@app.route('/document', methods=['PUT'])
def update_document():
  return put(request, mongo.db.documents)
#def

@app.route('/comment/<string:the_date>', methods=['GET'])
def get_comment(the_date):
  return get(mongo.db.comments,the_date)
#def

@app.route('/comment', methods=['POST'])
def add_comment():
  return post(request, mongo.db.comments)
#def

@app.route('/comment', methods=['PUT'])
def update_comment():
  return put(request, mongo.db.comments)
#def

@app.route('/audit/<string:the_date>', methods=['GET'])
def get_audit(the_date):
  return get(mongo.db.audits,the_date)
#def

@app.route('/audit', methods=['POST'])
def add_audit():
  return post(request, mongo.db.audits)
#def

@app.route('/audit', methods=['PUT'])
def update_audit():
  return put(request, mongo.db.audits)
#def

@app.route('/activityhistory/<string:the_date>', methods=['GET'])
def get_activityhistory(the_date):
  return get(mongo.db.activityhistories,the_date)
#def

@app.route('/activityhistory', methods=['POST'])
def add_activityhistory():
  return post(request, mongo.db.activityhistories)
#def

@app.route('/activityhistory', methods=['PUT'])
def update_activityhistory():
  return put(request, mongo.db.activityhistories)
#def


if __name__ == '__main__':
    app.run(debug=True)
