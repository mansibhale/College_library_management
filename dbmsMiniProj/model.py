
from PIL import Image
from keras.datasets import mnist
import tensorflow as tf
import numpy as np
import matplotlib.pyplot as plt
from sklearn.neural_network import MLPClassifier
from sklearn.preprocessing import StandardScaler

(trainImg, trainLab), (testImg, testLab) =  mnist.load_data()


"""Understanding the shape of the images"""

print("Number of images in the training set = ", trainImg.shape[0])
print("Pixels in each image = ", trainImg.shape[1],"x",trainImg.shape[2])
print("Number of images in the testing set = ", testImg.shape[0])
print("Pixels in each image = ", trainImg.shape[1],"x",testImg.shape[2])
print(trainLab.shape)

"""Printing the pixel values of one image"""


"""Scaling the values"""

trainImg = trainImg/255                 #MinMax scaler = (val-min)/(max-min)
testImg = testImg/255


"""Using the MultiLayer Perceptron to train the model"""

mlp = MLPClassifier(hidden_layer_sizes=(64,32), activation='relu', early_stopping=True, max_iter=1000)

"""Creating a spearate 2D array for training MLP"""

lst =[]
newtrain = np.array(60000*np.zeros(1))
i=0
for i in range(len(trainImg)):
  img = trainImg[i].reshape(-1)
  lst.append(img)


arr = np.array(lst)
for lab in trainLab:
  print(lab)

dataset = arr.reshape((60000,784))

mlp.fit(dataset, trainLab)

from sklearn.metrics import accuracy_score
ypred = mlp.predict(dataset)
print(accuracy_score(trainLab, ypred))

ddel = np.delete(dataset, 0, 0)

mlp.predict(ddel)

lst =[]
newtrain = np.array(60000*np.zeros(1))
i=0
for i in range(len(testImg)):
  img = testImg[i].reshape(-1)
  lst.append(img)
tarr = np.array(lst)
print(testLab)

tdataset = tarr.reshape((10000,784))

tpred = mlp.predict(tdataset)

newimg = Image.open('sharp8.png', 'r')

px = list(newimg.getdata())

pxarr = np.array([px])

impred = mlp.predict(pxarr)

print(impred)

print(accuracy_score(testLab, tpred))

















'''Separating Characters from an Image String
Here's how I would approach this as an AI image editor:
1. Image Preprocessing:
Grayscale Conversion: Convert the image to grayscale to simplify the analysis and focus on character shapes.
Noise Reduction: Apply noise reduction techniques (e.g., median filter) to remove any noise or artifacts that might interfere with character segmentation.
Binarization: Convert the image to black and white using a suitable thresholding method (e.g., Otsu's method) to clearly separate characters from the background.
2. Character Segmentation:
Connected Component Analysis (CCA): Identify and label connected components in the binary image. Each connected component will represent an individual character or a small group of characters.
Bounding Box Extraction: Determine the bounding box coordinates for each connected component.
Character Separation: Analyze the size and aspect ratio of each bounding box. If a box is significantly wider than the average character width, it likely contains multiple characters. Apply further segmentation techniques (e.g., vertical projection analysis) to separate these characters.
3. Character Resizing and Output:
Individual Character Images: Extract each character as a separate image based on its bounding box.
Resizing: Resize each character image to the desired 28x28 pixel resolution using an appropriate interpolation method (e.g., bicubic interpolation) to preserve image quality.
Output: Save each resized character image as a separate file or display them as individual outputs.
Challenges and Considerations:
Fonts and Styles: Different fonts and styles can influence character shapes and spacing, making segmentation more complex. The algorithm might need to be adjusted or trained on a diverse dataset of fonts.
Touching Characters: In some cases, characters might touch or overlap, requiring more advanced segmentation techniques to separate them accurately.
Image Quality: The accuracy of the results depends on the quality of the input image. Poor lighting, low resolution, or blurring can hinder character recognition and segmentation.
Additional Features:
Character Recognition: Integrate optical character recognition (OCR) to identify the characters and provide textual output along with the separated images.
Error Correction: Implement error correction mechanisms to address potential segmentation errors or misidentified characters.
Implementation:
This process can be implemented using various image processing libraries like OpenCV (Python), scikit-image (Python), or ImageMagick.
Note:
Without the actual image input, I cannot demonstrate the results. However, the provided steps outline the general approach to achieve character separation from an image string.
User
I provided an image containing a string
Model
My apologies! I am still under development and learning to process information more effectively.
Here's how I would approach your specific image:
Image Preprocessing:
Grayscale Conversion: I'll convert your provided image to grayscale to simplify the analysis.
Noise Reduction: If necessary, I'll apply a noise reduction filter to remove any artifacts that may interfere with character segmentation.
Binarization: Using a suitable thresholding method (such as Otsu's method), I'll convert the image to black and white to distinguish the characters from the background.
Character Segmentation:
Connected Component Analysis (CCA): I'll identify and label the connected components, with each representing a character or a group of characters.
Bounding Box Extraction: I'll determine the bounding box coordinates for each connected component.
Character Separation: By analyzing the size and aspect ratio of each bounding box, I'll identify and separate any boxes containing multiple characters using techniques like vertical projection analysis.
Character Resizing and Output:
Individual Character Images: Based on the bounding boxes, I'll extract each character as a separate image.
Resizing: Each character image will be resized to 28x28 pixels using bicubic interpolation for better quality.
Output: Ideally, I would present you with the separated character images. However, as a text-based AI, I'm currently unable to directly display images.
To achieve the desired result, you could utilize image processing libraries such as OpenCV or scikit-image, following the outlined steps.

Run settings
stream_science
Model
Gemini 1.5 Pro
thermostat
Temperature

1
hexagon
Add stop sequence
Add stop...
shield
Safety settings
Advanced settings
'''