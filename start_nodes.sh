#!/bin/bash

# Change the terminal title to "Node-Red terminal"
echo -ne "\033]0;Node-Red Terminal\007"

# Function to kill process listening on a specific port
kill_process_on_port() {
    local port=$1
    local pid=$(sudo lsof -t -i :$port)
    if [ -n "$pid" ]; then
        echo "Killing process on port $port."
        sudo kill -9 "$pid"
    else
        echo "No process found listening on port $port."
    fi
}

# Navigate to the ROS workspace, build, and return to the initial directory
cd ros2_ws/
colcon build
cd -

# Open terminals for ROS2 nodes with titles
gnome-terminal -- bash -c 'echo -ne "\033]0;TM Driver Terminal\007"; source ~/.bashrc; ros2 run tm_driver tm_driver robot_ip:=192.168.5.10; exec bash' &
gnome-terminal -- bash -c 'echo -ne "\033]0;Joint Subscriber Terminal\007"; source ~/.bashrc; ros2 run joint_listener joint_subscriber; exec bash' &
gnome-terminal -- bash -c 'echo -ne "\033]0;Unity Subscriber Terminal\007"; source ~/.bashrc; ros2 run joint_listener unity_subscriber; exec bash' &
gnome-terminal -- bash -c 'echo -ne "\033]0;ArUco Detector Terminal\007"; source ~/.bashrc; ros2 run joint_listener aruco_detector; exec bash' &

sleep 15

node-red
