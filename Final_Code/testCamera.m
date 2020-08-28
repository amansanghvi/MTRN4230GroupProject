
cameraParams = get_kinect_camera_params('checkboard.png','checkboard-2.png');

%ipaddress = '10.10.14.73';
%robotType = 'Gazebo';
%setenv('ROS_MASTER_URI','http://10.10.14.73:11311');
%setenv('ROS_IP','10.10.14.64');
%rosshutdown;
%rosinit(ipaddress);
%blockposes = rossubscriber('/gazebo/link_states');
%pause(2);
%posdata = receive(blockposes,10);
%imSub = rossubscriber('/camera/color/image_raw');
%pcSub = rossubscriber('/camera/depth/points');


testIm  = imread('testImage.png');
imshow(testIm);
hold on;
centroids = GetObjectLocations(testIm,...
            [ShapeColourEnum.Red, ShapeColourEnum.Square]);
plot(centroids(:,1), centroids(:,2), 'w+');
worldCoords = CameraToWorldLocation(centroids,cameraParams);
disp(centroids);
disp(worldCoords);
