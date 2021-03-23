import os
import bindings
from bindings import python_binding
import time
import threading
import jamotools
import requests
import bs4
from bs4 import BeautifulSoup
import re
from korean_romanizer.romanizer import Romanizer
import sys

v = "alo"
t = 3

def generate_train_set():
    mtch = []
    page = requests.get("https://en.wikipedia.org/wiki/Hangul_Syllables").text
    td = BeautifulSoup(page,'lxml')
    x = re.compile(r"[\uAC00-\uD7A3]")
    p = td.find_all('td')
    for j in p:
        m = str(j).split()
        if len(m) == 1 :
            n = x.search(u'{m}'.format(m=j))
            if n != None:
                mtch.append(n.group(0))
                yield n.group(0)
        else:
            pass

def execution():
    g = generate_train_set()
    engine = jamotools.Vectorizationer(rule=jamotools.rules.RULE_1,max_length=3,prefix_padding_size=0)
    while True:
        v = next(g)
        try:
            v0 = engine.vectorize(v).tolist()
            r = engine.vectorize(Romanizer(v).romanize()).tolist()
            v = {"input":v0,"output":r}
            print("piping....")
            python_binding.modifyInfo('plugs/plugBoard.json',["speaker1","speaker0"],"1","bejkpqrstw",v)
        except AttributeError :
            print("exception found")
            pass

        time.sleep(5)

    threading.Timer(t, execution).start()

if __name__ == "__main__":
    execution()

        
