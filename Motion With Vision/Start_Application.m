clear all;
close all;

ipaddress = '10.10.14.65';
robotType = 'Gazebo'
setenv('ROS_MASTER_URI','http://10.10.14.65:11311')
setenv('ROS_IP','10.10.14.64')
rosshutdown;
rosinit(ipaddress);
%blockposes = rossubscriber('/gazebo/link_states');
%pause(2);
%posdata = receive(blockposes,10);
%imSub = rossubscriber('/camera/color/image_raw');
%pcSub = rossubscriber('/camera/depth/points');

%testIm  = readImage(imSub.LatestMessage);
%imshow(testIm);
%rostopic list;
motion_with_vision();





