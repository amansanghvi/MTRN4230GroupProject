%% 

scene = imread('shapes.png');
%scene = imread('scene.jpg');
[rows, cols, colours] = size(scene);

% Show original image
scenePlot = figure(1);
imshow(scene);
title('Original Image');
saveas(gcf,'scene_original.png');

% Take mask of blue shapes
blueMaskedPlot = figure(2);
blueMasked = blueMask(scene);
imshow(blueMasked);
title('Blue objects');

% Take mask of red shapes
redMaskedPlot = figure(3);
redMasked = redMask(scene);
imshow(redMasked);
title('Red objects');

% Take mask of green shapes
greenMaskedPlot = figure(4);
greenMasked = greenMask(scene);
imshow(greenMasked);
title('Green objects');

% Label objects of blue colour and find region properties
[labeledImage,numberOfObjects] = bwlabel(blueMasked);
blobMeasurements = regionprops(labeledImage,'Perimeter','Area', 'Centroid','Circularity'); 
circularities = [blobMeasurements.Perimeter].^2 ./ (4 * pi * [blobMeasurements.Area]);
figure(blueMaskedPlot);
label(numberOfObjects,circularities,blobMeasurements);
saveas(gcf,'blue_shapes.png');

% Label objects of green colour and find region properties
[labeledImage,numberOfObjects] = bwlabel(greenMasked);
blobMeasurements = regionprops(labeledImage,'Perimeter','Area', 'Centroid','Circularity'); 
circularities = [blobMeasurements.Perimeter].^2 ./ (4 * pi * [blobMeasurements.Area]);
figure(greenMaskedPlot);
label(numberOfObjects,circularities,blobMeasurements);
saveas(gcf,'green_shapes.png');

% Label objects of red colour and find region properties
[labeledImage,numberOfObjects] = bwlabel(redMasked);
blobMeasurements = regionprops(labeledImage,'Perimeter','Area', 'Centroid','Circularity'); 
circularities = [blobMeasurements.Perimeter].^2 ./ (4 * pi * [blobMeasurements.Area]);
figure(redMaskedPlot);
label(numberOfObjects,circularities,blobMeasurements);
saveas(gcf,'red_shapes.png');
