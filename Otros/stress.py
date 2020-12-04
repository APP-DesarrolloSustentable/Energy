import sys
import random
import string
from random import randrange

def rand_str(length):
	letters = string.ascii_lowercase
	return ''.join(random.choice(letters) for i in range(length))
	
def rand_date():
	return str(randrange(2020))+"-"+str(randrange(12))+"-"+str(randrange(28))
	
def rand_arq():
	check = randrange(2)
	if check==1:
		return "Adulto"
	else:
		return "Adulto"


class Logger(object):
    def __init__(self):
        self.terminal = sys.stdout
        self.log = open("lol.csv", "a")

    def write(self, message):
        self.terminal.write(message)
        self.log.write(message)  

    def flush(self):
        #this flush method is needed for python 3 compatibility.
        #this handles the flush command by doing nothing.
        #you might want to specify some extra behavior here.
        pass    


sys.stdout = Logger()

for x in range(0, 10000):
	print(rand_str(8)+","+rand_str(8)+","+rand_str(8)+","+rand_date()+","+rand_arq()+","+rand_str(16)+"@"+rand_str(8)+".com,"+rand_str(8)+","+rand_str(64))
	
#print("       ______")
#print("  .---<__. \\ \\")
#print("  `---._  \\ \\ \\")
#print("   ,----`- `.))")
#print("  / ,--.   )  |")
#print(" /_/    >     |")
#print(" |,\__-'      |")
#print("  \\_           \\")
#print("    ~~-___      )")
#print("          \\      \\")