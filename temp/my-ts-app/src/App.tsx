import React, { useState, useEffect } from 'react';
import Controller from './components/controller';
import './css_files/App.css'
import axios from 'axios';

const App: React.FC = () => {
  const [options, setOptions] = useState([
    { label: 'Option 1', frequency: 100 },
    { label: 'Option 2', frequency: 200 },
    { label: 'Option 3', frequency: 300 },
    { label: 'Option 4', frequency: 400 },
    { label: 'Option 5', frequency: 500 },
  ]);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await axios.get('http://localhost:5000/api/data');
        const receivedOptions = response.data.options;

        // Ensure that the receivedOptions is an array before setting the state
        if (Array.isArray(receivedOptions)) {
          setOptions(receivedOptions);
        } else {
          console.error('Invalid data format for options:', receivedOptions);
        }
      } catch (error) {
        console.error('Error fetching data:', error);
      }
    };

    fetchData();
  }, []);

  return (
    <div>
      <h1>React Controller App</h1>
      <Controller options={options} />
    </div>
  );
};

export default App;
