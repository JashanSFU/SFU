import Parameters.constants as Constants
import sys
import os

submodule_path = os.path.join(os.path.dirname(__file__), '..', '..', 'Diligent_WaveForms_SDK')
sys.path.append(submodule_path)

from WF_SDK import device

def turnOn(toggle: bool):
    try:
        if(toggle):
            Constants.device_data = device.open()
            print("Machine Turned on")
            return 0
        else:
            device.close(Constants.device_data)
            Constants.device_data = None
            print("Machine Turned off")
            return -1
    except: 
        print("Error in turning machine on/off")
    return