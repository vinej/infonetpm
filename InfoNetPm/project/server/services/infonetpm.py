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
    print("get company")
    return ipm_get(mongo.db.companies, the_date)


@app.route('/company', methods=['POST'])
def add_company():
    return ipm_post(request, mongo.db.companies)


@app.route('/company', methods=['PUT'])
def update_company():
    return ipm_put(request, mongo.db.companies)


@app.route('/resource/<string:the_date>', methods=['GET'])
def get_resource(the_date):
    return ipm_get(mongo.db.resources, the_date)


@app.route('/resource', methods=['POST'])
def add_resource():
    return ipm_post(request, mongo.db.resources)


@app.route('/resource', methods=['PUT'])
def update_resource():
    return ipm_put(request, mongo.db.resources)


@app.route('/activity/<string:the_date>', methods=['GET'])
def get_activity(the_date):
    return ipm_get(mongo.db.activities, the_date)


@app.route('/activity', methods=['POST'])
def add_activity():
    return ipm_post(request, mongo.db.activities)


@app.route('/activity', methods=['PUT'])
def update_activity():
    return ipm_put(request, mongo.db.activities)


@app.route('/project/<string:the_date>', methods=['GET'])
def get_project(the_date):
    return ipm_get(mongo.db.project, the_date)


@app.route('/project', methods=['POST'])
def add_project():
    return ipm_post(request, mongo.db.plans)


@app.route('/project', methods=['PUT'])
def update_project():
    return ipm_put(request, mongo.db.project)


@app.route('/plan/<string:the_date>', methods=['GET'])
def get_plan(the_date):
    return ipm_get(mongo.db.plans, the_date)


@app.route('/plan', methods=['POST'])
def add_plan():
    return ipm_post(request, mongo.db.plans)


@app.route('/plan', methods=['PUT'])
def update_plan():
    return ipm_put(request, mongo.db.plans)


@app.route('/issue/<string:the_date>', methods=['GET'])
def get_issue(the_date):
    return ipm_get(mongo.db.issues, the_date)


@app.route('/issue', methods=['POST'])
def add_issue():
    return ipm_post(request, mongo.db.issues)


@app.route('/issue', methods=['PUT'])
def update_issue():
    return ipm_put(request, mongo.db.issues)


@app.route('/role/<string:the_date>', methods=['GET'])
def get_role(the_date):
    return ipm_get(mongo.db.roles, the_date)


@app.route('/role', methods=['POST'])
def add_role():
    return ipm_post(request, mongo.db.roles)


@app.route('/role', methods=['PUT'])
def update_role():
    return ipm_put(request, mongo.db.roles)


@app.route('/order/<string:the_date>', methods=['GET'])
def get_order(the_date):
    return ipm_get(mongo.db.orders, the_date)


@app.route('/order', methods=['POST'])
def add_order():
    return ipm_post(request, mongo.db.orders)


@app.route('/order', methods=['PUT'])
def update_order():
    return ipm_put(request, mongo.db.orders)


@app.route('/status/<string:the_date>', methods=['GET'])
def get_status(the_date):
    return ipm_get(mongo.db.status, the_date)


@app.route('/status', methods=['POST'])
def add_status():
    return ipm_post(request, mongo.db.status)


@app.route('/status', methods=['PUT'])
def update_status():
    return ipm_put(request, mongo.db.status)


@app.route('/document/<string:the_date>', methods=['GET'])
def get_document(the_date):
    return ipm_get(mongo.db.documents, the_date)


@app.route('/document', methods=['POST'])
def add_document():
    return ipm_post(request, mongo.db.documents)


@app.route('/document', methods=['PUT'])
def update_document():
    return ipm_put(request, mongo.db.documents)


@app.route('/comment/<string:the_date>', methods=['GET'])
def get_comment(the_date):
    return ipm_get(mongo.db.comments, the_date)


@app.route('/comment', methods=['POST'])
def add_comment():
    return ipm_post(request, mongo.db.comments)


@app.route('/comment', methods=['PUT'])
def update_comment():
    return ipm_put(request, mongo.db.comments)


@app.route('/audit/<string:the_date>', methods=['GET'])
def get_audit(the_date):
    return ipm_get(mongo.db.audits, the_date)


@app.route('/audit', methods=['POST'])
def add_audit():
    return ipm_post(request, mongo.db.audits)


@app.route('/audit', methods=['PUT'])
def update_audit():
    return ipm_put(request, mongo.db.audits)


@app.route('/activityhistory/<string:the_date>', methods=['GET'])
def get_activityhistory(the_date):
    return ipm_get(mongo.db.activityhistories, the_date)


@app.route('/activityhistory', methods=['POST'])
def add_activityhistory():
    return ipm_post(request, mongo.db.activityhistories)


@app.route('/activityhistory', methods=['PUT'])
def update_activityhistory():
    return ipm_put(request, mongo.db.activityhistories)


if __name__ == '__main__':
    app.run(debug=True)
