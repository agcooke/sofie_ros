/*
 * rosserial potentiometer
 * Prints potentiometer value
 */

#include <ros.h>
#include <std_msgs/Int16.h>

ros::NodeHandle  nh;  //instantiate the node handle

std_msgs::Int16 int16_msg; // set int16 messagetype (a/d converter is 10 bit)
ros::Publisher angle("angle", &int16_msg);  //instantiate Publisher 'angle' with topic name "chatter"

int sensorPin = A0;    // select the input pin for the potentiometer
int sensorValue = 0;

void setup()
{
  nh.initNode();       //initialyse ROS node
  nh.advertise(angle); //advertise topic "angle"
  Serial.begin(57600); //set baudrate
}

void loop()
{
  sensorValue = analogRead(sensorPin); //read analog value
  int16_msg.data = sensorValue;
  angle.publish( &int16_msg );         //publish angle      
  nh.spinOnce();                       //handle ROS communications callbacks
  //delay(0);                          //sampling interval
}
