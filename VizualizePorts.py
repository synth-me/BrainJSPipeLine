import numpy as np
import matplotlib.pyplot as plt
import json
import datetime
from datetime import datetime
import sys
import time

point_list_x = []
point_list_y = []

error_y = []

counter = 0
fig, (ax1, ax2) = plt.subplots(1, 2)
fig.suptitle('speaker and error rate by time')

while True:
    try:
        d = datetime.now()


        with open("plugs/plugBoard.json",'r') as Json :
            j = json.load(Json)

        with open("plugs/error.json",'r') as Json :
            je = json.load(Json)


        state = j["1"][0]["round"]

        d = counter
        point_list_x.append(d)
        point_list_y.append(state)
        error_y.append(round(je['error'],6))

        Y,y = np.unique(point_list_y, return_inverse=True)

        ax1.plot(point_list_x,y,color="red")
        ax2.plot(point_list_x,error_y,color="blue")

        counter+=1
    except:
        pass

    plt.pause(0.5)


plt.show()
