import numpy as np
import matplotlib.pyplot as plt
from matplotlib.collections import LineCollection

file = open("mfcc_2_3.txt", 'r')
points = []

f = file.read()
lines = f.split('\n')

for line in lines:
    points.append([float(v) for v in line.split()])

file.close()

for point in points:
    plt.axis('equal')
    plt.plot(point[0],point[1], 'rx', markersize=4)

plt.xlabel('c2')
plt.ylabel('c3')
plt.title('MFCC')
plt.grid(True)
plt.show()