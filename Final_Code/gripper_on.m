function gripper_on(robot) 
    for i=1:length(robot.gripperOn)
        call(robot.gripperOn(i), rosmessage('std_srvs/Empty'));
    end
end