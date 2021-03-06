function motion_with_vision_kinematics
    clear all;
    close all;
    global robot;
    global topics;
    
    tftree = rostf;
    pause(2);
    tftree.AvailableFrames

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
    robot.POS_RETRACT_ORIGIN = [0,   -1.44,  1.4, -pi/2, -pi/2, 0];
    robot.POS_RETRACT_DEST = [0, -1.44,  1.4, -pi/2, -pi/2, 0];
    robot.POS_EXTEND_ORIGIN = [0,   -pi/2+phi, (pi/2-phi)+theta, -pi/2-theta, -pi/2, 0];
    robot.POS_EXTEND_DEST = [-pi/2, -pi/2+phi, (pi/2-phi)+theta, -pi/2-theta, -pi/2, 0];
    robot.duration = 2;

    waypoints = [robot.POS_RETRACT_ORIGIN; 
                 robot.POS_EXTEND_ORIGIN;
                 robot.POS_RETRACT_ORIGIN;
                 robot.POS_RETRACT_DEST;
                 robot.POS_EXTEND_DEST;
                 robot.POS_RETRACT_DEST];

    topics.ARM_STATE = "/arm_controller/state";
    topics.LINK_STATES = "/gazebo/link_states";
    topics.MODEL_STATE = "/gazebo/set_model_state";
    topics.ARM_COMMAND = "/arm_controller/command";
    % Obtain the current state of the robot.
    stateSubscriber = rossubscriber(topics.ARM_STATE);
    pause(1);
    % Get jointNames from current state.
    robot.jointNames = stateSubscriber.LatestMessage.JointNames;
    ipaddress = '192.168.1.109';
%     ipaddress = '10.10.14.65';
%     ipaddress = '10.10.14.24';
    robot.robotType = 'Gazebo';

    rosshutdown;
    rosinit(ipaddress);
    
    blockposes = rossubscriber(topics.LINK_STATES);
    pause(1);
    posdata = receive(blockposes,10);

    % Publishes commands to robot.
    positionPublisher = rospublisher(topics.ARM_COMMAND);

    % Used to move the kinect to (-2, 0, 0).
    modelPublisher = rospublisher(topics.MODEL_STATE);
    %modelMsg = modelPublisher.rosmessage();
    %modelMsg.ModelName = 'kinect_ros';
    %modelMsg.ReferenceFrame = 'world';
    %modelMsg.Pose.Position.X = -2;
    %send(modelPublisher, modelMsg);
    pause(2);


    % Get an empty message.
    msg = positionPublisher.rosmessage();
    % Set the timestamp to set an endtime 
    msg = initPositionMessage(msg);
  
    % Should be completed in 2 seconds from Header.Stamp
    msg.Points.TimeFromStart = rosduration(2);
    % Initially in the first position
    msg.Points.Positions = waypoints(1,:);

    count = 0;
    imSub = rossubscriber('/camera/color/image_raw');


    disp("Starting loop...");
    img_fig = figure(1);
    tab_fig = figure(2);
    
    %% Inverse Kinematics Generate UR5 Model in MATLAB
    mdl_ur5;
    
    %  Defined Current Pose Joint Angles 
    origin = [0,   -1.44,  1.4, -pi/2, -pi/2, 0];
    ti = origin;
 
    %%  TEST Coordinates: 
    % Random Shape Pose (World Frame)
    bp_pose = zeros(3,1);
    bp_pose(1) = 0.643728;
    bp_pose(2) = 1.242460;
    bp_pose(3) = 0.849991;
    
    % Box Pose (World Frame)
    box_pose = zeros(3,1);
    box_pose(1) = 0.25;
    box_pose(2) = 0.5;
    box_pose(3) = 0.85;
    
    
    while(1)

        % Sends joint angles to UR5
        % Origin Position
        msg = moveToPos(positionPublisher, msg, origin);
        count = count + 1;
        
        % Moves to the shape
        nextWaypoint = ur5_ikin(bp_pose(1),bp_pose(2),bp_pose(3),ti,ur5);
        msg = moveToPos(positionPublisher, msg, nextWaypoint);
        count = count + 1;
        
        % Origin Position
        msg = moveToPos(positionPublisher, msg, origin);
        count = count + 1;
        
        % Moving to the Box Pose
        nextWaypoint = ur5_ikin(box_pose(1),box_pose(2),box_pose(3),ti,ur5);
        msg = moveToPos(positionPublisher, msg, nextWaypoint);
        count = count + 1;
        
        % Shows Kinect Vision
        disp(msg.Points.Positions);
        count = count + 1;
        im  = readImage(imSub.LatestMessage);
        test_object_detection(im,img_fig, tab_fig);
        
        
    end
end

function msg = initPositionMessage(msg)
    global robot;
    global topics;
    msg.Header.Stamp = rostime("now");
    msg.JointNames = robot.jointNames;
    
    stateSubscriber = rossubscriber(topics.ARM_STATE);
    pause(1);
    msg.Points = stateSubscriber.LatestMessage.Desired;
    % Should be completed in 'robot.duration' seconds from Header.Stamp
    msg.Points.TimeFromStart = rosduration(robot.duration);
end

function [msg] = moveToPos(publisher, msg, waypoint)
    msg.Points.Positions = waypoint;
    msg.Header.Stamp = rostime("now");
    
    send(publisher,msg);
    pause(msg.Points.TimeFromStart.Sec+1);
    pause(5);
end


