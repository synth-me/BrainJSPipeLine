import sys
import os
import json

def passInfo(file,current_speaker,port,key,callback):

    with open(file,'r',encoding='utf8') as JsonFile :
        plugBoard = json.load(JsonFile)

    found = plugBoard[port][0][key]
    round = plugBoard[port][0]["round"]

    speaker = current_speaker[0]
    the_other = current_speaker[1]

    if round == speaker :
        callback(found)
        plugBoard[port][0]["round"] = the_other
        with open(file,'w',encoding='utf8') as JsonFile :
            json.dump(plugBoard,JsonFile,indent=4)

    return "done"

def modifyInfo(file,current_speaker,port,key,ndata):

    with open(file,'r',encoding='utf8') as JsonFile :
        plugBoard = json.load(JsonFile)

    found = plugBoard[port][0][key]
    round = plugBoard[port][0]["round"]

    speaker = current_speaker[0]
    the_other = current_speaker[1]

    if round == speaker :
        plugBoard[port][0][key] = ndata
        plugBoard[port][0]["round"] = the_other
        with open(file,'w',encoding='utf8') as JsonFile :
            json.dump(plugBoard,JsonFile,indent=4)

    return "done"
