import cv2
import numpy as np
from utils import get_lenet
from load_mnist import load_mnist
from scipy.io import loadmat
from conv_net import convnet_forward
from init_convnet import init_convnet
import matplotlib.pyplot as plt
from sklearn import metrics
import sklearn

# Load the model architecture
layers = get_lenet(1)
params = init_convnet(layers)

# Load the network
data = loadmat('../results/lenet.mat')
params_raw = data['params']

for params_idx in range(len(params)):
    raw_w = params_raw[0,params_idx][0,0][0]
    raw_b = params_raw[0,params_idx][0,0][1]
    assert params[params_idx]['w'].shape == raw_w.shape, 'weights do not have the same shape'
    assert params[params_idx]['b'].shape == raw_b.shape, 'biases do not have the same shape'
    params[params_idx]['w'] = raw_w
    params[params_idx]['b'] = raw_b

for i in range(4):
    # Load and preprocess the image
    I = cv2.imread('../images/image{}.jpg'.format(i+1)) if i != 2 else cv2.imread('../images/image{}.png'.format(i+1))
    I = cv2.cvtColor(I, cv2.COLOR_BGR2GRAY)

    if i == 3:
        kernelSize = 1
        threshold = 200
    if i == 4:
        kernelSize = 1
        threshold = 20
    else:
        kernelSize = 1
        threshold = 150
        
    structured = cv2.getStructuringElement(cv2.MORPH_RECT, (kernelSize, kernelSize))
    background = cv2.morphologyEx(I, cv2.MORPH_OPEN, structured)
    BlackWhiteData = cv2.bitwise_not(background)
    BlackWhiteData[BlackWhiteData < threshold] = 0
    BlackWhiteData[BlackWhiteData > threshold] = 255

    com = com.astype(np.float32) / 255.0

    num_labels, labels, stats, centroids = cv2.connectedComponentsWithStats(BlackWhiteData.astype(np.uint8), connectivity=8)
    
    all_preds = []
    for label in range(num_labels - 1):
        x, y, width, height, _ = stats[label+1]
        digit = BlackWhiteData[y:y+height, x:x+width]
       
        digit = cv2.resize(digit,(28,28), interpolation= cv2.INTER_AREA)
        
        cptest, P = convnet_forward(params, layers, digit, test=True)
        preds = np.argmax(P, axis=0)
        all_preds.extend(preds)
       
    print("Output for image{} is :{}".format(i,all_preds))