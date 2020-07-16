cd ~/simulation_ws
catkin_make
source devel/setup.bash
export SVGA_VGPU10=0
export ROS_IP=10.10.14.65
export GAZEBO_MODEL_PATH='/home/javad/simulation_ws/src/ur5_t2_4230/models'
export ROS_MASTER_URI=http://10.10.14.65:11311
roslaunch ur5_t2_4230 ur5_world.launch
