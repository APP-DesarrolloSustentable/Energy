import bcrypt
import codecs


def encode(password): 
    password = codecs.encode(password)
    hashed = bcrypt.hashpw(password, bcrypt.gensalt())
    return codecs.decode(hashed)

def check(password, hashed):
    password = codecs.encode(password)      
    hashed = codecs.encode(hashed)  
    if bcrypt.checkpw(password, hashed):
        return True
    else:
        return False

