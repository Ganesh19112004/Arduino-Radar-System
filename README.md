# Radar System Using Arduino Uno and Processing

## Overview
This project demonstrates how to build a radar system using Arduino Uno, servo motor, ultrasonic sensor, and Processing. The system is designed to scan the environment using an ultrasonic sensor and visualize the scanned data on a graphical interface. The radar system detects objects and displays their distance in real-time using the Processing framework.

The radar system uses the Arduino board to control the hardware components and Processing to create a graphical interface that shows the scanned data in the form of a radar-like display.

## Components Required
- **Arduino Uno**
- **Servo Motor (SG90 or similar)**
- **Ultrasonic Sensor (HC-SR04)**
- **DC Motor**
- **Motor Driver (L298N or similar)**
- **Breadboard**
- **Jumper Wires**
- **Power Supply (for Arduino and motors)**

## Circuit Setup

| **Component**           | **Connection Details**                                           |
|-------------------------|------------------------------------------------------------------|
| **Ultrasonic Sensor (HC-SR04)** | VCC to 5V on Arduino<br>GND to GND on Arduino<br>Trig Pin to Pin 9 on Arduino<br>Echo Pin to Pin 10 on Arduino  |
| **Servo Motor (SG90)**      | VCC to 5V on Arduino<br>GND to GND on Arduino<br>Control Pin to Pin 6 on Arduino |
| **DC Motor**               | Connected to motor driver (L298N)                              |
| **Motor Driver (L298N)**     | IN1 to Pin 3 on Arduino<br>IN2 to Pin 4 on Arduino<br>VCC to external power supply (based on motor specs)<br>GND to Arduino GND |
| **Power Supply**           | Power Arduino using USB or 5V power adapter<br>External power (usually 12V) for DC motor |

## Installation Steps

### 1. Set Up Hardware
- Follow the wiring guide above to connect the components on the breadboard and Arduino.
- Make sure the power connections are correct for each component.
- Power the Arduino using USB or external power.
- If necessary, power the DC motor using an external power supply.

### 2. Arduino IDE Code
- Open the Arduino IDE, write or paste the provided Arduino code.
- Upload the code to the Arduino board using the Arduino IDE.

### 3. Processing Code
- Open Processing and create a new .pde file to visualize the data from the Arduino.
- The Processing sketch will communicate with the Arduino over the serial port to receive distance readings and display them in real-time.

### 4. Run Both Software
- Run the Processing sketch to display the graphical interface.
- Ensure the Arduino IDE is running and the code is uploaded to the Arduino board.

## How It Works

### Arduino Controls the Hardware:
- The Arduino controls the servo motor to rotate the ultrasonic sensor and scan the environment.
- The ultrasonic sensor measures the distance of objects in front of it by emitting a sound wave and measuring the time it takes for the wave to return.
- The DC motor rotates the entire radar system, providing a broader scanning angle.

### Processing Visualizes the Data:
- The Processing software reads data from the Arduino via a serial connection.
- The received distance data is visualized as a radar scan, showing the distance of detected objects as dots around a central radar display.

## Features
- **Radar Display**: Real-time radar-like display showing distances of objects in different directions.
- **Smoothing Effect**: Objects are displayed as semi-transparent dots with a trailing effect for smoother visualization.
- **Distance Measurement**: Measures the distance of objects within a defined range (0 to 40 cm).
- **Servo Sweep**: The ultrasonic sensor scans from 0° to 180° and back, providing a sweeping radar effect.
- **Data Display**: Displays angle and distance data on the screen for detailed feedback.

## Troubleshooting

1. **Servo Not Moving**
   - Ensure the servo is properly connected to the correct Arduino pin and powered sufficiently.

2. **No Distance Reading**
   - Verify that the Trig and Echo pins are correctly connected to the ultrasonic sensor and that it is powered.

3. **Processing Not Displaying Data**
   - Ensure the correct serial port is selected in the Processing code and that the Arduino is sending data correctly.

## Enhancements
- **Increased Radar Range**: Use a more powerful ultrasonic sensor for a greater detection range.
- **Real-Time Data**: Improve the visualization by adding distance markers or grid lines to the radar.
- **Wireless Communication**: Integrate Bluetooth or Wi-Fi for remote communication between Arduino and the Processing application.
- **Multi-Sensor Setup**: Add more ultrasonic sensors for wider coverage or more precise readings.

## Conclusion
This project demonstrates the integration of hardware (Arduino, servo motor, ultrasonic sensor) and software (Processing) to create a simple radar system. The radar system provides real-time scanning and displays the detected objects on a graphical interface. This can be further enhanced with additional sensors or features like obstacle avoidance or wireless data transmission.
