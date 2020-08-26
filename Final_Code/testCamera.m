centroids = GetObjectLocations(imread('world1.png'),...
            [ShapeColourEnum.Blue, ShapeColourEnum.Square, ShapeColourEnum.Triangle]);
cameraParams = get_kinect_camera_params('checkboard.png','checkboard-2.png');
worldCoords = CameraToWorldLocation(centroids,cameraParams);