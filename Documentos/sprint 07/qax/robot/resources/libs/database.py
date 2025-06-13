from pymongo import MongoClient
import bcrypt
from robot.api.deco import keyword
client = MongoClient('mongodb+srv://QAX1:Xperience@cluster0.vyklavr.mongodb.net/markdb?retryWrites=true&w=majority&appName=Cluster0')
db = client['markdb']

@keyword('Remove user from database')
def remove_user(email):
    users = db['users']
    users.delete_many({'email': email})
    print("remove user " + email)

@keyword('Insert user from database')
def insert_user(user):
    hash_pass = bcrypt.hashpw(user['password'].encode('utf-8'), bcrypt.gensalt(8))
    doc = {
        'name': user['name'],
        'email': user['email'],
        'password': hash_pass
    }

    users = db['users']
    users.insert_one(doc)
    print('inser user ' + doc)