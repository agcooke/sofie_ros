Sofie bicycle steering angle sensor
======
Author: jcjbeers@g<you now where>.com

This document describes how to setup and tweak the Sofie bicycle steering sensor.

The sensor system consists of a potentiometer with a continuous range and an Arduino nano prototyping board which
broadcasts a topic on ROS.

Assuming that ROS 'groovy' is already installed, installing the rosserial\_arduino package is all thats needed to 
get the sensor to run. A tutorial on rosserial_arduino can be found at [http://www.ros.org/wiki/rosserial_arduino/
Tutorials].


### Download and install rosserial_arduino

1.   Download and install from repository.


	$ sudo apt-get install ros-groovy-rosserial

### Using steering sensor (without sofie_ros)

Of course ROS should run.
	$ roscore
When the sensor is plugged in a device will appear in /dev/ (eg /dev/ttyUSB0).
Connect this device with ROS.

	$ rosrun rosserial_python serial_node.py /dev/ttyUSB0

The sensor will broadcast data on a topic named 'angle'. A simple csv-file can be created by saving incoming
 data and correlating linux-timestamp.
 
	$ rostopic echo -p /angle > filename.csv

When using the SOFIE GUI a file consisting all of the sensor data can be created. This would include a 
.bag-file with the steering angle data.

__The arduino steering sensor file is now integrated fully into the sofie\_ros system using the 
launch/simple_bridge_normal.launch file.__

### Altering the sensor firmware

This requires Arduino software, which is based on java. So if you don't have it installed yet:

	$sudo apt-get install openjdk-7-jre

Make sure the Braille-keyboard is not installed (this step might not be necessary).

	$ sudo apt-get remove brltty

Then install the Arduino software

	$ sudo apt-get install arduino

Follow the instructions on the ROS website: [http://www.ros.org/wiki/rosserial_arduino/Tutorials/Arduino%20IDE%20Setup]

If you get the error:

	In file included from /home/${USER}/sketchbook/libraries/ros_lib/ros.h:39:0,
	                 from anglevalue.cpp:6:
	/home/${USER}/sketchbook/libraries/ros_lib/ArduinoHardware.h:38:22: fatal error: WProgram.h: No such file or directory
	compilation terminated.

then add the following line to /home/${USER}/sketchbook/libraries/ros_lib/ArduinoHardware.h:

	#if defined(ARDUINO) && ARDUINO >= 100
	  #include "Arduino.h"
	#else
	  #include "WProgram.h"
	  #include <pins_arduino.h>
	#endif
	
instead of:

	  #include "WProgram.h"

The Arduino firmware is available in the file anglevalue.ino file. When uploading to the board remember to specify
the correct board that you use (We have a Arduino Nano).

