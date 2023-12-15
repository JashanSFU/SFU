import numpy as np

def inner_product_forward(input, layer, param):
    """
    Forward pass of inner product layer.

    Parameters:
    - input (dict): Contains the input data.
    - layer (dict): Contains the configuration for the inner product layer.
    - param (dict): Contains the weights and biases for the inner product layer.
    """

    d, k = input["data"].shape
    n = param["w"].shape[1]

    ###### Fill in the code here ######
    result = np.matmul(param['w'].T, input['data'])
    result = result + param["b"].T
    # Initialize output data structure
    output = {
        "height": n,
        "width": 1,
        "channel": 1,
        "batch_size": k,
        "data": result # replace 'data' value with your implementation
    }

    return output

def inner_product_backward(output, input_data, layer, param):
    """
    Backward pass of inner product layer.

    Parameters:
    - output (dict): Contains the output data.
    - input_data (dict): Contains the input data.
    - layer (dict): Contains the configuration for the inner product layer.
    - param (dict): Contains the weights and biases for the inner product layer.
    """
    param_grad = {}
    
    param_grad['w'] = np.dot(input_data['data'],output['diff'].T)
    
    param_grad['b'] = np.sum(output['diff'],axis=1)
    input_od = np.dot(param['w'], output['diff'])

    
    return param_grad, input_od
