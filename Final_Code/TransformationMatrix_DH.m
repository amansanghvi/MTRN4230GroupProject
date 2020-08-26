
%% DH Parameter table
function T_i = TransformationMatrix_DH(DH_parameters)
    theta_i = DH_parameters(1);
    d_i = DH_parameters(2);
    a_i = DH_parameters(3);
    alpha_i = DH_parameters(4);
    
%   General Transformation matrix  
    T_i = [[cos(theta_i), -sin(theta_i)*cos(alpha_i), sin(theta_i)*sin(alpha_i), a_i*cos(theta_i)]; ...
           [sin(theta_i), cos(theta_i)*cos(alpha_i), -cos(theta_i)*sin(alpha_i), a_i*sin(theta_i)]; ...
           [0           , sin(alpha_i)             , cos(alpha_i)              , d_i];              ...
           [0           , 0                        , 0                         , 1 ]];

end


           
