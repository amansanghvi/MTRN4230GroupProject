function gripper_off(robot) 
    for i=1:length(robot.gripperOff)
        call(robot.gripperOff(i), rosmessage('std_srvs/Empty'));
    end
end