'''
Created on Oct 3, 2015

@author: rhondusmithwick
To simulate data of students in Wannamaker
'''
import random
def getemail(x):
    return x+ "@duke.edu"
def netiddorm(n):
    alph="abcdefghijklmnopqrstuv"
    numbers="0123456789"
    netids=set()
    while len(netids) < n:
        netid=''.join([random.choice(alph) for i in range(3)])
        netid+= random.choice(numbers)+random.choice(numbers)
        if netid not in All_Netids:
            netids.add(netid)
            All_Netids.add(netid)
    return sorted(netids)

        
if __name__ == '__main__':
    All_Netids=set()
    All_Emails=[]
    Wanny_Netids=netiddorm(200)
    Wanny_Emails=map(getemail,Wanny_Netids)
    All_Emails+=Wanny_Emails
    file = open("WannyStudents.txt", "w")
    for i in range(len(Wanny_Netids)):
        mystring=Wanny_Netids[i]+" "+ Wanny_Emails[i]
        file.write(mystring)
        if i <len(Wanny_Netids) -1:
            file.write("\n")
    file.close()
        