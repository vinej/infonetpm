# mongo.py
from flask import request, make_response, jsonify
from project.server.models import User
from project.server.auth.views import is_bad_token
from project.server import app, mongo


def get_date(date_str="", the_format="%Y-%m-%dT%H:%M:%S%z"):
    from datetime import datetime
    if not date_str:
        return datetime.today().date()
    return datetime.strptime(date_str, the_format).date()


def ipm_get(documents, sdate):
    print(request.headers)
    if not check_token(request.headers['Authorization']):
        return response_401(request)
    # if

    output = []
    for d in documents.find({'updatedDate': {'$gte': sdate}}):
        d.pop('_id')
        output.append(d)
    # for
    print(output)
    return jsonify({'result': output})


def response_401(the_request):
    response_object = \
        dict(
             status='401',
             redirect=the_request.url,
             message='BadToken or no auth_token')
    resp = jsonify(response_object)
    resp.status_code = 401
    return resp


def check_token(auth_token):
    if not auth_token:
        return False

    # bearer TOKEN
    auth_token = auth_token[7:]
    resp = User.decode_auth_token(auth_token)
    if is_bad_token(resp):
        return False

    return True


def ipm_post(the_request, documents):
    print(the_request.json)
    if the_request.json is None:
        return
    # if
    if not check_token(the_request.headers['auth_token']):
        return response_401(the_request)
    # if

    the_request.json['isNew'] = False
    the_request.json['isSync'] = True
    mongo_id = documents.insert(the_request.json)
    output = documents.find_one({'_id': mongo_id})
    output.pop("_id")
    print(output)
    return jsonify({'result': output})


def ipm_put(the_request, documents):
    print(the_request.json)
    if not check_token(the_request.headers['auth_token']):
        return response_401(the_request)
    # if

    the_request.json['isNew'] = False
    the_request.json['isSync'] = True
    old = documents.find_one({'id': the_request.json["id"]})
    output = documents.replace_one(old, the_request.json)
    print(output)
    return jsonify({'result': output})


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
