import numpy as np


def main(data):
    print(data)

def relu_forward(input_data):
    output = {
        'height': input_data['height'],
        'width': input_data['width'],
        'channel': input_data['channel'],
        'batch_size': input_data['batch_size'],
    }

    ###### Fill in the code here ######
    # Replace the following line with your implementation. 
    
    output['data'] = np.where(input_data['data'] > 0 , input_data['data'], 0)
    
    return output

def relu_backward(output, input_data, layer):
    ###### Fill in the code here ######
    # Replace the following line with your implementation.
   
    input_od = np.zeros_like(input_data['data'])

    for i in range(input_data['data'].shape[0]):
        for j in range(input_data['data'].shape[1]):
            input_od[i,j] = output['diff'][i,j] if (input_data['data'][i,j] >= 0) else 0
    return input_od
