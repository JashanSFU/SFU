from flask import Flask, jsonify, request
from flask_cors import CORS
from Hardware_components.frequencySet import set_frequency
from Hardware_components.turnOnOff import turnOn
import concurrent.futures


# app = Flask(__name__)
# CORS(app)
app = Flask(__name__)

app = Flask(__name__)
CORS(app, resources={r"/api/*": {"origins": "*"}}, supports_credentials=True)
# CORS(app, resources={r"/api/*": {"origins": "http://localhost:3000"}})

# Define data globally
data = {
    'options': [
        { 'label': 'Option 1', 'frequency': 5e6 },
        { 'label': 'Option 2', 'frequency': 10e6 },
        { 'label': 'Option 3', 'frequency': 23e6 },
        # { 'label': 'Option 4', 'frequency': 4 },
    ]
}

####################################################################################################################
####################################################################################################################
####################################################################################################################

@app.route('/api/data', methods=['GET'])
def get_data():
    return jsonify(data)

####################################################################################################################
####################################################################################################################
####################################################################################################################
global frequency_thread
frequency_thread = None
# global device_data 
# device_data = None
# def set_frequency_async(frequencies):
#     global frequency_thread
#     if frequency_thread and frequency_thread.is_alive():
#         # If a thread is already running, stop it before starting a new one
#         frequency_thread.cancel()
#         frequency_thread.join()

#     # Start a new thread
#     frequency_thread = concurrent.futures.ThreadPoolExecutor().submit(set_frequency, frequencies)
#     return 0

@app.route('/api/data', methods=['POST'])
def add_data():
    new_option = request.json 
    
    apply_frequencies = new_option['frequencies']
    # Use concurrent.futures to run set_frequency in a separate thread
    # with concurrent.futures.ThreadPoolExecutor() as executor:
    #     future = executor.submit(set_frequency_async, apply_frequencies)
    set_frequency(apply_frequencies)
    # # Wait for the result
    # result = future.result()
    
    return jsonify({'status': 201})
####################################################################################################################
####################################################################################################################
####################################################################################################################

@app.route('/api/on', methods=['GET'])
def turn_on():
    if(turnOn(True) == 0):
        return jsonify({'status': 200})
    else:
        return jsonify({'status': 404})

####################################################################################################################
####################################################################################################################
####################################################################################################################

@app.route('/api/off', methods=['GET'])
def turn_off():
    if(turnOn(False) == -1):
        return jsonify({'status': 200})
    else:
        return jsonify({'status': 404})

####################################################################################################################
####################################################################################################################
####################################################################################################################

if __name__ == '__main__':
    app.run(debug=True)
