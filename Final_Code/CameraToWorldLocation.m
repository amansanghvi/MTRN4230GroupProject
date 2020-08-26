function worldCoords = CameraToWorldLocation(centroids,cameraParams)
    %Camera Intrinscis Captured From ROS Message at '/camera/color/camera_info'
    %The intrinsics come from the K field of the messsage
    %focalLength = [5.542559711879749e+02 5.542559711879749e+02];
    %principalPoint = [3.205000000000000e+02 2.405000000000000e+02];
    %imageSize = [480 640];
    %intrinsics = cameraIntrinsics(focalLength,principalPoint,imageSize);
    worldPts = [0.787, 0.952;
                0.583, 0.953;
                0.442, 0.969;
                0.476, 1.412;
                0.588, 1.173];
            
    imagePts = [352.2, 52.41;
                351.3, 185.8;
                340.9, 278.4;
                50.83, 255.6;
                207.1, 182.6];
    [R, t] = extrinsics(imagePts, worldPts, cameraParams);        
    %rotationMatrix = eul2rotm([0 0 0],"XYZ");
    %translationVector = [-0.5 -1 -1.7];
    worldPoints = pointsToWorld(cameraParams,R,t,centroids);
    %table is fixed at 0.8m above table
    depths = ones(size(centroids,1),1)*0.85;
    worldCoords = [worldPoints depths];
end