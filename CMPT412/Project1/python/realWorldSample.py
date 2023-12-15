import numpy as np
from utils import get_lenet
from load_mnist import load_mnist
from scipy.io import loadmat
from conv_net import convnet_forward
from init_convnet import init_convnet
import matplotlib.pyplot as plt
from sklearn import metrics
import sklearn
import cv2 as cv


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

# Load data
loops = 6
for loop in range(loops):
    data = cv.imread('../TestingRealSample/{}.png'.format(loop+1))
    grayscale_data = cv.cvtColor(data, cv.COLOR_BGR2GRAY)
    grayscale_data = cv.resize(grayscale_data,(28,28), interpolation= cv.INTER_LINEAR)
    inverted_image = 255 - grayscale_data

    # Testing the network
    #### Modify the code to get the confusion matrix ####
    all_preds = []
    cptest, P = convnet_forward(params, layers, inverted_image, test=True)
    preds = np.argmax(P, axis=0)
    all_preds.extend(preds)
    print(all_preds)

