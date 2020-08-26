function move_to_pos(robot, new_angles)
    robot.posMsg.Points.Positions = new_angles;
    robot.posMsg.Header.Stamp = rostime("now");
    
    send(robot.posPublisher, robot.posMsg);
    pause(robot.posMsg.Points.TimeFromStart.Sec+1.5);
end