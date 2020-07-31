clc
clear all
close all
%% Test Script of UR5
% Gets fed initial joint angles + desired EE location
% Spits out desired EE joint angles

% Generate UR5 model
mdl_ur5

%%  Initial/Current Joint Angles
ti = [0,   -1.44,  1.4, -pi/2, -pi/2, 0];

% Plot UR5 based on ti
ur5.plot(ti);

% (Received from ROS) Desired EE Pose
x_ee = 0.6;
y_ee = 0.2;
z_ee = 0.1;
roll = 0; 
pitch = 180;
yaw = -90;

%% IK: Find desired theta values + pose wrt initial pose
% tee:  Desired End Effector Joint Angles
[tee,T] = ur5_ikin(x_ee,y_ee,z_ee,roll,pitch,yaw,ti,ur5)

% Plots desired pose of EE as coordinate frame
hold on
trplot(T)

% Moves UR5 to desired pose
ur5.plot(tee)