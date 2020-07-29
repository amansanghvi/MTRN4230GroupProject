% Object detection v2
% z5116787, Jason Phu
% For MTRN4230 Group assignment, T2.2020
%
% Provide image and code will supply table with all shapes and their
% colours and locations

%% Read in images

%scene = imread('shapes.png');
scene = imread('scene.jpg');
[rows, cols, colours] = size(scene);

% Show original image
fig = figure(1);
fig.WindowState = 'Maximized';
scenePlot = subplot(2,2,1);
imshow(scene);
title('Original Image');

%% Process images to mask colours

redMasked = redMask(scene);
redMasked = imerode(redMasked,strel('disk',2));
greenMasked = greenMask(scene);
greenMasked = imerode(greenMasked,strel('disk',2));
blueMasked = blueMask(scene);
blueMasked = imerode(blueMasked,strel('disk',2));

%% Process to detect shapes and fill table
% Preallocate table to hold shapes
shapes = table('Size',[0 4],'VariableTypes',{'categorical','double','double','categorical'});
shapes.Properties.VariableNames = {'Colour','Centroid','Circularity','Shape'};

% Label objects of red colour and find region properties
[labeledImage,numberOfObjects,blobMeasurements, circularities] = blob_detect(redMasked);
% Take mask of red shapes
redMaskedPlot = subplot(2,2,2);
imshow(redMasked);
title('Red objects');
col = 'Red';
label(numberOfObjects,circularities,blobMeasurements);

% Add to table
for i = 1:size(blobMeasurements,1)
    shapes = [shapes;add_shapes(blobMeasurements(i),col);];
end

% Label objects of green colour and find region properties
[labeledImage,numberOfObjects,blobMeasurements, circularities] = blob_detect(greenMasked);
% Take mask of green shapes
greenMaskedPlot = subplot(2,2,3);
imshow(greenMasked);
title('Green objects');
col = 'Green';
label(numberOfObjects,circularities,blobMeasurements);

% Add to table
for i = 1:size(blobMeasurements,1)
    shapes = [shapes;add_shapes(blobMeasurements(i),col);];
end

% Label objects of blue colour and find region properties
[labeledImage,numberOfObjects,blobMeasurements, circularities] = blob_detect(blueMasked);
blueMaskedPlot = subplot(2,2,4);
imshow(blueMasked);
title('Blue objects');
col = 'Blue';
label(numberOfObjects,circularities,blobMeasurements);

% Add to table
for i = 1:size(blobMeasurements,1)
    shapes = [shapes;add_shapes(blobMeasurements(i),col);];
end

saveas(gcf,'analysis.png');

%% Create and display table with information on all detected objects

uitab = uifigure;
uit = uitable(uitab);
uit.Data = shapes;
uit.ColumnSortable = [true false false true];
uit.Position = [15 15 500 400];

%% Get statistics on the analysed image - categorical

% Show data summary for colours and shapes
summary(shapes,1)
summary(shapes,4)
s = summary(shapes);

% cat_count = table('Size',[4 3],'VariableTypes',{'uint8','uint8','uint8'});
% cat_count.Properties.VariableNames = {'Red','Green','Blue'};
% cat_count.Properties.RowNames = {'Rectangle','Circle','Triangle','Pentagon'};

% cat_count({'Rectangle'},{'Blue'}) = sum(shapes.Colour == 'Blue' & shapes.Shape == 'Rectangle')
