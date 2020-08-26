function main
    robot = initialise();
    
    [total_picks, shapes, colors] = pick_ui();
    shape_color_enum = [shapes, colors];
    
    for i=1:total_picks
        move_to_pos(robot, robot.POS_HOME);
        img = rossubscriber(robot.IMG_TOPIC);
        locs = camera_to_world(get_obj_locations(img, shape_color_enum));
        pickup_pos = ur5_ikin(locs(0,1), locs(0,2), locs(0,3));
        gripper_on();
        move_to_pos(robot, pickup_pos);
        move_to_pos(robot, robot.POS_BOX);
        gripper_off();
    end
    % get_obj_locations(image, [shape_colour_enum]) -> vector of centroids [x, y]; Camera frame
    % Camera to world -> camera centroids to world centroids.
    % inv_kine to get joint position
    % place robot above box to drop.
end



