function main
    clear('global')
    [shape_color_vals, total_picks,ipaddress] = pick_ui();
    robot = initialise(ipaddress);
    imgSub = rossubscriber(robot.IMG_TOPIC);
    pause(0.3)
    figure('Position',[100 500 500 400]);
    i = 1;
    while i <= total_picks
        disp("Picking Object: " + i);
        move_to_pos(robot, robot.POS_BOX);  
        img = readImage(imgSub.LatestMessage);
        
        
        
        centroids = GetObjectLocations(img, shape_color_vals);
        
        if(isempty(centroids))
            plot_image(img,centroids,0)
            shape_color_vals = pick_ui();
            centroids = GetObjectLocations(img, shape_color_vals);
            %Check there are still objects to be picked
            if(isempty(centroids))
                move_to_pos(robot, robot.POS_HOME);
                no_more_picks_ui_update()
                return;
            end
            continue;
        end
        
        chosen_index =randperm(size(centroids,1),1);
        plot_image(img,centroids,chosen_index)
        locs = CameraToWorldLocation(centroids, robot.cameraParams);
        pickup_pos = ur5_ikin(locs(chosen_index,1), locs(chosen_index,2),...
                              locs(chosen_index,3), robot.ur5, robot.POS_HOME);
        
        move_to_pos(robot, robot.POS_HOME);
        move_to_pos(robot, pickup_pos);
        pause(0.3);
        gripper_on(robot);
        pause(0.3);
        move_to_pos(robot, robot.POS_HOME);
        move_to_pos(robot, robot.POS_BOX);
        pause(0.3);
        gripper_off(robot);
        update_ui(i);
        i = i + 1;
    end
    move_to_pos(robot, robot.POS_HOME);
    program_completed();
end

function plot_image(img,centroids,chosen_index)
    imshow(img,'InitialMagnification','fit');
    hold on;
    if(chosen_index > 0)
        viscircles(centroids, ones(size(centroids,1),1)*30,'Color','w','LineWidth',2,'LineStyle',':');
        viscircles(centroids(chosen_index,:), 30,'Color','g','LineWidth',2);
    end
    plot(NaN,NaN,'-w');
    plot(NaN,NaN,'-g');
    title('Robot Vision Output');
    lgnd = legend('Identified Objects', 'Selected Object');
    set(lgnd,'color','none');
    set(lgnd,'TextColor','w');
    set(lgnd,'Location','southeast');
end

function update_ui(pickNumber)
    global ui;
    ui.pickscompleted.Text = "Picks Completed: " + pickNumber;
end

function no_more_picks_ui_update()
    global ui;
    ui.title.Text = "No More Detected Objects To Be Picked"; 
end

function program_completed()
    global ui;
    ui.title.Text = "Pick and Place Task Completed"; 
end


