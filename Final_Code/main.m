function main
    robot = initialise();
    
    [total_picks, shape_color_vals] = pick_ui();
    disp(shape_color_vals);
    imgSub = rossubscriber(robot.IMG_TOPIC);
    pause(0.3)
    for i=1:total_picks
        move_to_pos(robot, robot.POS_BOX);  
        img = readImage(imgSub.LatestMessage);
        imshow(img)
        hold on;
        centroids = GetObjectLocations(img, shape_color_vals);
        plot(centroids(:,1),centroids(:,2));
        locs = CameraToWorldLocation(centroids, robot.cameraParams);
        pickup_pos = ur5_ikin(locs(1,1), locs(1,2), locs(1,3), robot.ur5, robot.POS_HOME);
        
        move_to_pos(robot, robot.POS_HOME);
        move_to_pos(robot, pickup_pos);
        pause(0.3);
        gripper_on(robot);
        pause(0.3);
        move_to_pos(robot, robot.POS_HOME);
        move_to_pos(robot, robot.POS_BOX);
        pause(0.3);
        gripper_off(robot);
    end
    move_to_pos(robot, robot.POS_HOME);
end



