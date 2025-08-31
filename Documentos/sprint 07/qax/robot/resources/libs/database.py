from robot.api.deco import keyword
from pymongo import MongoClient
import bcrypt

client = MongoClient('mongodb+srv://QAX1:Xperience@cluster0.vyklavr.mongodb.net/markdb?retryWrites=true&w=majority&appName=Cluster0')

db = client['markdb']

@keyword('Clean user from database')
def clean_user(user_email):
    users = db['users']
    tasks = db['tasks']
    user = users.find_one({'email': user_email})
    if(user):
        tasks.delete_many({'user': user['_id']})
        users.delete_many({'email': user_email})


@keyword('Remove user from database')
def remove_user(email):
    users = db['users']
    users.delete_many({'email': email})
    print("User removed successfully " + email)

@keyword('Insert user from database')
def insert_user(user):
    hash_pass= bcrypt.hashpw(user['password'].encode('utf-8'), bcrypt.gensalt(8))
    doc = {
        'name': user['name'],
        'email': user['email'],
        'password': hash_pass
    }
    users = db['users']
    users.insert_one(doc)
    print(user)



