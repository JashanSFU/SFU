// Controller.tsx

import React, { useState, useEffect } from 'react';
import '../css_files/controller.css'; // Import the CSS file
import ToggleButton from './powerButton';
import axios from 'axios';
import { stat } from 'fs';

async function get_turnOn(state: boolean){
  let api_endpoint;
  if(state){
    api_endpoint = 'http://localhost:5000/api/on'
  }
  else{
    api_endpoint = 'http://localhost:5000/api/off'
  }
  try {
    const response = await axios.get(api_endpoint);
    if(response.status === 200)
      console.log("Turned machine on/off successfully")
    else
      console.error("Failed to do the task")

  } catch (error) {
    console.error('Error:', error);
  }
}


async function post_frequency (frequencies: number[]){
  try {  
    const response = await axios.post('http://localhost:5000/api/data', {frequencies:frequencies}, {
      headers: {
        'Content-Type': 'application/json',
      },
    });
    
    if(response.status === 200)
      console.log("Frequency generation started ")
    else
      console.error("Failed to set frequency")
  } catch (error) {
    console.error('Error setting frequency', error);
  }
}


interface ControllerProps {
  options: { label: string; frequency: number }[];
}



const Controller: React.FC<ControllerProps> = ({ options }) => {
  
  const [selectedOptions, setSelectedOptions] = useState<string[]>([]);
  // const [selectedOption, setSelectedOption] = useState<string>('');
  
  const [selectedFrequencies, setSelectedFrequencies] = useState<number[]>([]);
  // const [frequency, setFrequency] = useState<number | null>(null);
  const [toggle, setToggle] = useState(false);


  const handleOptionClick = async (option: string, frequency: number) => {
    if (selectedOptions.includes(option)) {
      setSelectedOptions(selectedOptions.filter((selected) => selected !== option));
      setSelectedFrequencies(selectedFrequencies.filter((selected) => selected !== frequency));
    } 
    else {
      setSelectedOptions([...selectedOptions,option]);
      setSelectedFrequencies([...selectedFrequencies, frequency]);
    }
  };

  useEffect(() => {
    if(selectedFrequencies.length != 0){
      post_frequency(selectedFrequencies);
    }
  }, [selectedOptions, selectedFrequencies]);

  const handleToggle = async (state: boolean) => {
    setToggle(state);
    get_turnOn(state);
    if(!state){
      setSelectedOptions([]);
      setSelectedFrequencies([]);
    }
  };
  
  return (
    <div className="controller-container">
      <h2>Controller</h2>
      <ToggleButton onToggle={handleToggle} />
      <div className="options-container">
        {options.map((option) => (
          <button
            key={option.label}
            className={`option-button  ${selectedOptions.includes(option.label) ? 'selected' : ''}`}
            onClick={() => handleOptionClick(option.label, option.frequency)}
            disabled={!toggle}
          >
            {option.frequency + " Hz "}
          </button>
        ))}
      </div>
    </div>
  );
};

export default Controller;
