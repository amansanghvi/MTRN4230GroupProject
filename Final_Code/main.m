function main
    robot = initialise();
    
    [total_picks, shape_color_vals] = pick_ui();
  
    for i=1:total_picks
        move_to_pos(robot, robot.POS_BOX);
        imgSub = rossubscriber(robot.IMG_TOPIC);
        img = readImage(imgSub.LatestMessage);
        
        locs = CameraToWorldLocation(GetObjectLocations(img, shape_color_vals), robot.cameraParams);
        pickup_pos = ur5_ikin(locs(1,1), locs(1,2), locs(1,3), robot.ur5, robot.POS_HOME);
        
        gripper_on(robot);
        move_to_pos(robot, pickup_pos);
        move_to_pos(robot, robot.POS_BOX);
        gripper_off(robot);
    end
end



