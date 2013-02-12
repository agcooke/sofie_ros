#!/usr/bin/env python
#
# Caution this file only imports the recorded values into the HDF file after the
#experiment is performed. The importARData function must thus be called.
# This is a hack because the PYTables does not allow concurrent writing to the file,
#thus a csv is created and then must be imported at a later stage. Needs refractoring.
import sys
#import roslib; roslib.load_manifest('sofie_ros')
import rospy
import os.path
from ar_track_alvar.msg import AlvarMarkers
from std_msgs.msg import Int16
from sofiehdfformat.core.SofieCsvPyTableAccess import SofieCsvPyTableAccess
from sofiehdfformat.core.SofieCsvParser import parse_sample_interpret as csv_sample_interpret
from sofiehdfformat.core.SofieCsvAccess import SofieCsvAccess
from sofiehdfformat.core.SofieCsvFile import CsvFile
from sofiehdfformat.core.SofieFileUtils import defaultQuaternionTableStructure,defaultAngleTableStructure
import time
import signal
csvWriter = None;
csvWriterArduino = None;

def getFileInfo(waitParam='/sofie/csvfilename'):
    '''
    Get the File info from the ros parameter server.
    '''
    csvfilename = None
    while csvfilename == None:
        try:
            csvfilename = rospy.get_param(waitParam)
        except KeyError:
            pass
    return csvfilename

def sofieWriterCallback(data):
    '''
    Implements a simple writer to CSV file for Quaternion data.
    '''
    rospy.logdebug(rospy.get_name() + ": Received Quaternion")
    rospy.logdebug(data)
    #HACK-> Getting firset marker.
    if not data.markers:
        return
    data = data.markers[0]
    csvWriter.write(
        (data.header.seq,
        data.confidence,
        data.pose.pose.position.x,
        data.pose.pose.position.y,
        data.pose.pose.position.z,
        data.pose.pose.orientation.w,
        data.pose.pose.orientation.x,
        data.pose.pose.orientation.y,
        data.pose.pose.orientation.z,
        data.header.stamp.to_time()))

    
def sofieArduinoWriterCallback(data):
    '''
    Implements a simple writer to CSV file for angle data.
    '''
    timestamp = time.time()
    rospy.logdebug(rospy.get_name() + ": Received Angle")
    rospy.logdebug(data)
    data = data.data
    csvWriterArduino.write((data,timestamp))

if __name__ == '__main__':
    csvfilename = getFileInfo()
    rospy.loginfo('Logging to file: {0}'.format(csvfilename))
    csvWriter = SofieCsvAccess(csvfilename, defaultQuaternionTableStructure)
    csvWriterArduino = SofieCsvAccess(getFileInfo(waitParam='/sofie/arduinocsvfilename'),
                                       defaultAngleTableStructure)
    try:
        rospy.init_node('sofiehdfformatwriter', anonymous=True)
        rospy.Subscriber("/ar_pose_marker", AlvarMarkers, sofieWriterCallback)
        rospy.Subscriber("/angle", Int16, sofieArduinoWriterCallback)
        rospy.spin()
    except:
          csvWriter.close()
          csvWriterArduino.close()      