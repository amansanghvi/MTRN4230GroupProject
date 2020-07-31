%% Forward Kinematics of UR5
function [x_ee,y_ee,z_ee]  = ur5_fkin(ti)

% ti: Initial theta values
theta1 = ti(1);
theta2 = ti(2);
theta3 = ti(3);
theta4 = ti(4);
theta5 = ti(5);
theta6 = ti(6);

% From UR5 manual/literature
d1 = 0.089159; 
a2 = -0.425; 
a3 = -0.39225;
d4 = 0.10915; 
d5 = 0.09465; 
d6 = 0.0823;  

% DH Table: theta_i [rad], d_i [m]  , a_i [m]    , alpha_i [rad]
% -----------------------------------------------------------------------
DH_table =  [[theta1      , d1       , 0          , 0           ]; ...
            [ theta2      , 0        , a2         , pi/2        ]; ...
            [ theta3      , 0        , a3         , 0           ]; ...
            [ theta4      , d4       , 0          , 0           ]; ...
            [ theta5      , d5       , 0          , pi/2        ]; ...
            [ theta6      , d6       , 0          , -pi/2       ]];
        
T_01 = TransformationMatrix_DH(DH_table(1,:))
T_12 = TransformationMatrix_DH(DH_table(2,:))
T_23 = TransformationMatrix_DH(DH_table(3,:))
T_34 = TransformationMatrix_DH(DH_table(4,:))
T_45 = TransformationMatrix_DH(DH_table(5,:))
T_56 = TransformationMatrix_DH(DH_table(6,:))

T = T_01*T_12*T_23*T_34*T_45*T_56;
ee = T*[0;0;0;1];
x = ee(1);
y = ee(2);
z = ee(3);
end
