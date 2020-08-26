function worldCoords = CameraToWorldLocation(centroids,cameraParams)
    %Camera Intrinscis Captured From ROS Message at '/camera/color/camera_info'
    %The intrinsics come from the K field of the messsage
    focalLength = [5.542559711879749e+02 5.542559711879749e+02];
    principalPoint = [3.205000000000000e+02 2.405000000000000e+02];
    imageSize = [480 640];
    intrinsics = cameraIntrinsics(focalLength,principalPoint,imageSize);
    rotationMatrix = eul2rotm([0 0 pi/2],"XYZ");
    translationVector = [0.5 1 2];
    worldPoints = pointsToWorld(cameraParams,rotationMatrix,translationVector,centroids);
    %table is fixed at 0.8m above table
    depths = ones(size(centroids,1),1)*0.8;
    worldCoords = [worldPoints depths];
end