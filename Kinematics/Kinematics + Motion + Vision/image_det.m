%%
image = imread('world1.png');

%im_size = size(image);
im_size = [895 1272];

shapes_table = test_object_detection(image);

%%
%load('point_cloud.mat');

%xyz = readXYZ(ptcloud);
%rgb = readRGB(ptcloud);

%scatter3(ptcloud);