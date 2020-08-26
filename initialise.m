function [robot] = initialise
    global topics;
    
    ipaddress = '192.168.0.41';
    robot.robotType = 'Gazebo';
    rosshutdown;
    rosinit(ipaddress);

    mdl_ur5;
    robot.ur5 = ur5;
    % Trajectory to cycle through.
    phi = pi/3.2;
    theta = pi/2.3;
    %      _ _ _ _ _
    %     /\ ?
    %    /  \ <- link2 of robot
    %   /    \
    % ?/      O <- spherical wrist.
    % /      
    %/ <- link1 of robot
    robot.POS_HOME = [0,   -1.44,  1.4, -pi/2, -pi/2, 0];
    robot.POS_BOX = [-pi/3, -pi/2+phi, (pi/2-phi)+theta, -pi/2-theta, -pi/2, 0];
    
    robot.duration = 1.5;

    topics.ARM_STATE = "/arm_controller/state";
    topics.LINK_STATES = "/gazebo/link_states";
    topics.MODEL_STATE = "/gazebo/set_model_state";
    topics.ARM_COMMAND = "/arm_controller/command";
    
    
    robot.gripperOn = rossvcclient("/ur5/vacuum_gripper/on");
    robot.gripperOff = rossvcclient("/ur5/vacuum_gripper/off");
    for i=1:8
        robot.gripperOn(i+1) = rossvcclient("/ur5/vacuum_gripper" + i + "/on");
        robot.gripperOff(i+1) = rossvcclient("/ur5/vacuum_gripper" + i + "/off");
    end
    robot.gripperMsg = rosmessage('std_srvs/Empty');

    % Publishes commands to robot.
    robot.posPublisher = rospublisher(topics.ARM_COMMAND);

    % Get an empty message.
    robot.posMsg = robot.posPublisher.rosmessage();
    % Set the timestamp to set an endtime 
    initPositionMessage(robot);
  
    % Should be completed in 2 seconds from Header.Stamp
    robot.posMsg.Points.TimeFromStart = rosduration(robot.duration);
    % Initially in the first position
    move_to_pos(robot, robot.POS_HOME);
    
    robot.imSub = rossubscriber('/camera/color/image_raw');
    
end

function initPositionMessage(robot)
    global topics;
    robot.posMsg.Header.Stamp = rostime("now");
    
    stateSubscriber = rossubscriber(topics.ARM_STATE);
    pause(1);
    robot.posMsg.Points = stateSubscriber.LatestMessage.Desired;
    robot.jointNames = stateSubscriber.LatestMessage.JointNames;
    robot.posMsg.JointNames = robot.jointNames;
    % Should be completed in 'robot.duration' seconds from Header.Stamp
    robot.posMsg.Points.TimeFromStart = rosduration(robot.duration);
end
