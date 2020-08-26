%% Inverse Kinematics using Peter Corke Toolbox
% Receives initial/current joint angles + desired EE pose
% Spits out desired joint angles
function [tee]  = ur5_ikin(x_ee,y_ee,z_ee, ur5, ti)

%% Converts world frame cartesian coordinates to UR5 base frame
ee_displacement = 0.01; % can change depending on size of EE
x_ee = -x_ee;
y_ee = 1 - y_ee;
z_ee = z_ee - 1 + ee_displacement;

%% These are fixed: for the EE
roll = 0; 
pitch = 180;
yaw = -90;

% Translation(x,y,z) + Orientation(roll, pitch, yaw) of desired pose
T = transl(x_ee,y_ee,z_ee)*rpy2tr(roll,pitch,yaw,'deg')

% IK: Finds desired theta angles for desired EE pose
% tee: desired joint angles 
tee = ur5.ikine(T, 'q0',ti)

end