%% Inverse Kinematics using Peter Corke Toolbox
% Receives initial/current joint angles + desired EE pose
% Spits out desired joint angles
function [tee,T]  = ur5_ikin(x_ee,y_ee,z_ee,roll, pitch,yaw,ti,ur5)

% Translation(x,y,z) + Orientation(roll, pitch, yaw) of desired pose
T = transl(x_ee,y_ee,z_ee)*rpy2tr(roll,pitch,yaw,'deg')

% IK: Finds desired theta angles for desired EE pose
% tee: desired joint angles 
tee = ur5.ikine(T, 'q0',ti)

end