clear all;
close all;
clc;
rosshutdown;
% ipaddress = '10.10.14.65';
ipaddress = '192.168.1.109';
robotType = 'Gazebo'
setenv('ROS_MASTER_URI','http://192.168.1.109:11311');
setenv('ROS_IP','192.168.1.101');

rosinit;

%blockposes = rossubscriber('/gazebo/link_states');
%pause(2);
%posdata = receive(blockposes,10);
%imSub = rossubscriber('/camera/color/image_raw');
%pcSub = rossubscriber('/camera/depth/points');

%testIm  = readImage(imSub.LatestMessage);
%imshow(testIm);
rostopic list;
motion_with_vision_kinematics();





