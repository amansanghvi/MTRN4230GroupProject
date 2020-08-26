function trajectory_motion
    clear all;
    close all;
    global robot;
    global topics;
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
    robot.POS_RETRACT_DEST = [-pi/2,   -1.44,  1.4, -pi/2, -pi/2, 0];
    robot.POS_EXTEND_ORIGIN = [0,   -pi/2+phi, (pi/2-phi)+theta, -pi/2-theta, -pi/2, 0];
    robot.POS_EXTEND_DEST = [-pi/2, -pi/2+phi, (pi/2-phi)+theta, -pi/2-theta, -pi/2, 0];
    robot.duration = 2;
    
    Q1 = robot.POS_EXTEND_ORIGIN;
    Q2 = robot.POS_RETRACT_ORIGIN;
    Q3 = robot.POS_EXTEND_DEST;

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
    topics.JOINT_GOAL  = "/arm_controller/follow_joint_trajectory/goal";
    topics.GOAL_ACTION = "/arm_controller/follow_joint_trajectory";

    ipaddress = '192.168.0.41';
    robot.robotType = 'Gazebo';

    rosshutdown;
    rosinit(ipaddress);
    
    % Obtain the current state of the robot.
    stateSubscriber = rossubscriber(topics.ARM_STATE);
    pause(1);
    % Get jointNames from current state.
    robot.jointNames = stateSubscriber.LatestMessage.JointNames;


    blockposes = rossubscriber(topics.LINK_STATES);
    pause(1);

    % Publishes commands to robot.
    positionPublisher = rospublisher(topics.ARM_COMMAND);
    goalPublisher = rospublisher(topics.JOINT_GOAL);
    [client, msg] = rosactionclient(topics.GOAL_ACTION);

    pause(1);

    msg.Trajectory.JointNames = robot.jointNames;

    p1 = stateSubscriber.LatestMessage.Actual;
    p1.Velocities = [0, 0, 0, 0, 0, 0];
    p1.Accelerations = [0, 0, 0, 0, 0, 0];
    p1.TimeFromStart = rosduration(0);
    % Position is same as actual.
    
    p2 = rosmessage("trajectory_msgs/JointTrajectoryPoint");
    p2.Velocities = [0, 0, 0, 0, 0, 0];
    p2.Accelerations = [0, 0, 0, 0, 0, 0];
    p2.TimeFromStart = rosduration(2.0);
    p2.Positions = Q1;
    
    p3 = rosmessage("trajectory_msgs/JointTrajectoryPoint");
    p3.Velocities = [0, 0, 0, 0, 0, 0];
    p3.Accelerations = [0, 0, 0, 0, 0, 0];
    p3.TimeFromStart = rosduration(3.0);
    p3.Positions = Q2;
    
    p4 = rosmessage("trajectory_msgs/JointTrajectoryPoint");
    p4.Velocities = [0, 0, 0, 0, 0, 0];
    p4.Accelerations = [0, 0, 0, 0, 0, 0];
    p4.TimeFromStart = rosduration(4.0);
    p4.Positions = Q3;
    
    msg.Trajectory.Points = [p1, p2, p3, p4];
    
    disp("Sending...");
    sendGoal(client, msg);
end