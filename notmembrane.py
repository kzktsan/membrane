import cv2
import numpy as np
import random

img = cv2.imread("/Users/satokazuki/Desktop/lined2.jpg")
img2 = cv2.imread("/Users/satokazuki/Desktop/ori.jpg")
length = 64
half = length/2
#f = open("/Users/satokazuki/Desktop/redlist.txt", 'w')

height = img.shape[0]
width = img.shape[1]

count = 0

while count < 100000:
	x = random.randint(0,width-1)
	y = random.randint(0,height-1)
	if not(img[y, x, 2] > 200 and img[y, x, 1] < 100 and img[y, x, 0] <100):
			if (y - half >= 0 and y + half < height and x - half >= 0 and x + half < width):
				copy = img2[y - half : y + half +1 , x - half : x + half +1]
				cv2.imwrite("/Users/satokazuki/Desktop/notmembrane/train" + str(count) + ".jpg", copy)
				count = count + 1

print(count)