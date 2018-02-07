# mongo.py
from flask import Flask
from flask import jsonify
from flask import request
from project.server import app

def date(datestr="", format="%Y-%m-%dT%H:%M:%S%z"):
  from datetime import datetime
  if not datestr:
    return datetime.today().date()
  return datetime.strptime(datestr, format).date()
#def

def get(documents, sdate) :
  if check_token(request.headers['auth_token']) == False:
    return Response401(request)
  #if
  output = []
  for d in documents.find({'updatedDate': {'$gte': sdate}}):
    d.pop('_id')
    output.append(d)
  #for
  print(output)
  return jsonify({'result' : output})
#def

def Response401(request):
    return # response 401, to retry to get a new token
    responseObject = {
    'status': 'fail',
    'message': 'BadToken or no auth_token',
    'redirect': request.url
    }
    return make_response(jsonify(responseObject)), 401
}

def check_token(auth_token):
  if auth_token == None:
    return False
    
  resp = User.decode_auth_token(auth_token)
  if isBadtoken(resp):
    return False

  return True
#def

def post(request, documents) :
  print(request.json)
  if (request.json is None):
    return
  #if
  if check_token(request.headers['auth_token']) == False:
    return Response401(request)
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
      if check_token(request.headers['auth_token']) == False:
      return Response401(request)
  #if
  
  request.json['isNew'] = False
  request.json['isSync'] = True
  old = documents.find_one({'id': json["id"] })
  output = documents.replace_one(old, request.json)
  print(output)
  return jsonify({'result' : output})
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
