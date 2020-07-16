function basic_motion
    clear all;
    close all;
    global robot;
    global topics;
    % Trajectory to cycle through.
    phi = pi/6;
    robot.POS_RETRACT_ORIGIN = [0,   -1.44,  1.4, -pi/2, -pi/2, 0];
    robot.POS_RETRACT_DEST = [-pi/2, -1.44,  1.4, -pi/2, -pi/2, 0];
    robot.POS_EXTEND_ORIGIN = [0, -phi,2*phi, -pi/2-phi, -pi/2, 0];
    robot.POS_EXTEND_DEST = [-pi/2, -phi,2*phi, -pi/2-phi, -pi/2,0];
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

    % ipaddress = '10.10.14.65';
    ipaddress = '10.10.14.24';
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
    modelMsg = modelPublisher.rosmessage();
    modelMsg.ModelName = 'kinect_ros';
    modelMsg.ReferenceFrame = 'world';
    modelMsg.Pose.Position.X = -2;
    send(modelPublisher, modelMsg);
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

    disp("Starting loop...");
    while(1)
        nextWaypoint = waypoints(mod(count, length(waypoints(:,1)))+1,:);

        msg = moveToPos(positionPublisher, msg, nextWaypoint);
        disp(msg.Points.Positions);

        count = count + 1;
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
end

