import React, { useState } from 'react';
import '../css_files/powerButton.css'; // Import a separate CSS file for styling

interface ToggleButtonProps {
  onToggle: (state: boolean) => void;
}

const ToggleButton: React.FC<ToggleButtonProps> = ({ onToggle }) => {
  const [isOn, setIsOn] = useState(false);

  const handleToggle = () => {
    const newState = !isOn;
    setIsOn(newState);
    onToggle(newState);
  };

  return (
    <button className={`toggle-button ${isOn ? 'on' : 'off'}`} onClick={handleToggle}>
      <div className="toggle-switch"></div>
      {/* <span>{isOn ? 'ON' : 'OFF'}</span> */}
    </button>
  );
};

export default ToggleButton;

