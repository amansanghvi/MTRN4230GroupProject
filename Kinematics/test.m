clc
clear all
close all

% Generate UR5 model
mdl_ur5

%%  Initial/Current Joint Angles
ti = [0,   -1.44,  1.4, -pi/2, -pi/2, 0];

% Plot UR5 based on
ur5.plot(ti);

% Desired EE Pose
x_ee = 0.6;
y_ee = 0.2;
z_ee = 0.1;
roll = 0; % All zero since we're not rotating the end effector
pitch = 180 ;
yaw = -90;

%% IK: Find desired theta values wrt initial pose based on desired EE pose
% tee:  Desired End Effector Theta Angles
[tee,T] = ur5_ikin(x_ee,y_ee,z_ee,roll,pitch,yaw,ti,ur5)

% Plots desired pose of EE
hold on
trplot(T)

% Moves UR5 to desired pose
ur5.plot(tee)