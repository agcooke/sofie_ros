Sofie bicycle steering angle sensor
======

This document describes how to setup and tweak the Sofie bicycle steering sensor.

The sensor system consists of a potentiometer with a continuous range and an Arduino nano prototyping board which
broadcasts a topic on ROS.

Assuming that ROS 'groovy' is already installed, installing the rosserial\_arduino package is all thats needed to 
get the sensor to run. A tutorial on rosserial_arduino can be found at [http://www.ros.org/wiki/rosserial_arduino/
Tutorials].


### Download and install rosserial_arduino

1.   Download and install from repository.

	$ sudo apt-get install ros-groovy-rosserial

### Using steering sensor

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



### Altering the sensor firmware

This requires Arduino software, which is based on java. So if you don't have it installed yet:

	$sudo apt-get install openjdk-7-jre

Make sure the Braille-keyboard is not installed.

	$ sudo apt-get remove brltty

Then install the Arduino software

	$ sudo apt-get install arduino

The Arduino firmware is available in the file anglevalue.pde file.

