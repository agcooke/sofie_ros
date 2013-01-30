cmake_minimum_required(VERSION 2.8.3)
project(sofie_ros)
find_package(catkin REQUIRED COMPONENTS rospy ar_track_alvar)

set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin)
set(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/lib)

catkin_package(
    DEPENDS rospy ar_track_alvar
    CATKIN-DEPENDS # TODO
    INCLUDE_DIRS # TODO include
    LIBRARIES # TODO
)