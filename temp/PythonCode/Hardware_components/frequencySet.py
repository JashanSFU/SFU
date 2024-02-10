from ast import List
# import time
import Parameters.constants as Constants
import sys
import os
from time import sleep  
submodule_path = os.path.join(os.path.dirname(__file__), '..', '..', 'Diligent_WaveForms_SDK')
sys.path.append(submodule_path)

from WF_SDK import wavegen, device, error

def set_frequency(frequencies: []):
    device_data = Constants.device_data
    if len(frequencies) == 1:
        try:
            wavegen.generate(device_data, channel=1, function=wavegen.function.sine, offset = 0 , frequency=frequencies[0], amplitude=5)
            sleep(10)
            # device.close(device_data)
        except error as e:
            print(e)
    else:
        try:
            while True:
                for frequency in frequencies:
                    # device_data = device.open()
                    wavegen.generate(device_data, channel=1, function=wavegen.function.sine, offset = 0 , frequency=frequency, amplitude=5)
                    sleep(0.01)
                    # if(frequency == 23e6):
                    #     print("3rd option")
                    # device.close(device_data)
        except error as e:
            print(f"Error generating signal for frequencies {frequencies}: {e}")
    return 0
     
    # """-----------------------------------"""

    # # handle devices without analog I/O channels
    # try:
    #     device_data = device.open()
    #     # initialize the scope with default settings
    #     # scope.open(device_data)

    #     # # set up triggering on scope channel 1
    #     # scope.trigger(device_data, enable=True, source=scope.trigger_source.analog, channel=1, level=0)

    #     # generate a 10KHz sine signal with 2V amplitude on channel 1
    #     wavegen.generate(device_data, channel=1, function=wavegen.function.sine, offset=0, frequency=5e06, amplitude=5)

    #     sleep(3)    # wait 1 second

    # # close the connection
    #     device.close(device_data)

    # except error as e:
    #         print(e)
    #         # close the connection
    #         device.close(device.data)
    # return 0