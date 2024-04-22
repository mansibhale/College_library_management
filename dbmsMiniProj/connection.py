from PIL import Image, ImageFilter
import cv2
import numpy as np

def resize(imgpath):
    img = Image.open(imgpath, 'r')
    newim = img.resize((28,28)).convert('L')
    px = list(newim.getdata())
    print(len(px))
    sharpim = newim.filter(ImageFilter.SHARPEN)
    sharpim2 = sharpim.filter(ImageFilter.SHARPEN)
    sharpim2.save('sharpim2.png')

resize('six.png')

img = Image.open('rezero.png', 'r')
px = list(img.getdata())
print(px)
print(len(px))

'''
px = list(newimg.getdata())

sharpened1 = newimg.filter(ImageFilter.SHARPEN)


sharpened2 = sharpened1.filter(ImageFilter.SHARPEN)

sharpened2.show()

sharpened2.save('sharp8.png')

print(len(px))

'''