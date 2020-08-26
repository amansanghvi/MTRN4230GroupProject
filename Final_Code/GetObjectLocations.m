% Object detection v2
% z5116787, Jason Phu
% for MTRN4230 Group assignment, T2.2020
%
% Provide image and code will supply table with all shapes and their

% colours and locations
%% Get Object Locations Function
function centroids = GetObjectLocations(scene,ShapeColour)
    centroids = [];
    % Search all red shapes
    if ismember(ShapeColourEnum.Red,ShapeColour)
        redMasked = redMask(scene);
        redMasked = imerode(redMasked,strel('disk',2));
    
        centroids = get_shape_centroids_from_colour(redMasked,ShapeColour, centroids);
       
    end
    
    if ismember(ShapeColourEnum.Green,ShapeColour)
        greenMasked = greenMask(scene);
        greenMasked = imerode(greenMasked,strel('disk',2));
        
        centroids = get_shape_centroids_from_colour(greenMasked,ShapeColour, centroids);
        
    end
    
    if ismember(ShapeColourEnum.Blue,ShapeColour)
        blueMasked = blueMask(scene);
        blueMasked = imerode(blueMasked,strel('disk',2));
        
        centroids = get_shape_centroids_from_colour(blueMasked,ShapeColour, centroids);
        
    end
    
    %{
    %% Process images to mask colours
    redMasked = redMask(scene);
    greenMasked = greenMask(scene);
    blueMasked = blueMask(scene);
    
    % Do a small erode open to remove noise
    redMasked = imerode(redMasked,strel('disk',2));
    greenMasked = imerode(greenMasked,strel('disk',2));
    blueMasked = imerode(blueMasked,strel('disk',2));
    
    %% Process to detect shapes and fill table
    
    % Preallocate table to hold shapes
    shapes = table('Size',[0 5],'VariableTypes',{'categorical','double','double','double','categorical'});
    
    % First value of centroid is horizontal coordinate, second is vertical coordinate
    shapes.Properties.VariableNames = {'Colour','Centroid','Circularity','Area','Shape'}; 
    
    % Label objects of red colour and find region properties
    [labeledImage,numberOfObjects,blobMeasurements] = blob_detect(redMasked);
    col = 'Red';
    
     % Add to table
    for i = 1:size(blobMeasurements,1)
        shapes = [shapes;add_shapes(blobMeasurements(i),col);];
    end
    
     % Label objects of green colour and find region properties
    [labeledImage,numberOfObjects,blobMeasurements] = blob_detect(greenMasked);
    col = 'Green';
    
      % Add to table
    for i = 1:size(blobMeasurements,1)
        shapes = [shapes;add_shapes(blobMeasurements(i),col);];
    end
    
      % Label objects of blue colour and find region properties
    [labeledImage,numberOfObjects,blobMeasurements] = blob_detect(blueMasked);
    col = 'Blue';
    
    % Add to table
    for i = 1:size(blobMeasurements,1)
        shapes = [shapes;add_shapes(blobMeasurements(i),col);];
    end
    
     uitab = uifigure;
     uit = uitable(uitab);
     uit.Data = shapes;
     uit.ColumnSortable = [true false true true true];
     uit.Position = [15 15 500 400];
    %}
end

%% Get Shapes centroids From Colour
function new_centroids = get_shape_centroids_from_colour(colourMask,ShapeColour, centroids)
    new_centroids = centroids;
    [labeledImage,numberOfObjects,blobMeasurements] = blob_detect(colourMask);
    for i = 1:size(blobMeasurements,1)
        shapeLabel = shape_detect(blobMeasurements(i));
        %disp(shapeLabel);
        if ismember(shapeLabel,ShapeColour)
            new_centroids = [new_centroids;blobMeasurements(i).Centroid];
        end
    end
end

%% Detct Shape Function
function shape = shape_detect(blobMeasurement)

n = blobMeasurement.Area;
k = blobMeasurement.Circularity;

if n < 450
        shape = ShapeColourEnum.Triangle;
    elseif n < 700 && k > 0.9
        shape = ShapeColourEnum.Circle;
    elseif n < 820 && k > 0.8
        shape = ShapeColourEnum.Pentagon;
    elseif n < 1000
        shape = ShapeColourEnum.Square;
else
    shape = ShapeColourEnum.Invalid;
end
  
end

%% Blob Detect Function
function [labeledImage,numberOfObjects,blobMeasurements] = blob_detect(maskedImage)

[labeledImage,numberOfObjects] = bwlabel(maskedImage);
blobMeasurements = regionprops(labeledImage,'Perimeter','Area', 'Centroid','Circularity'); 
%circularities = [blobMeasurements.Perimeter].^2 ./ (4 * pi * [blobMeasurements.Area]);
end

%% Add Shapes Function
function entry = add_shapes(blobMeasurement,shape_colour) %UNUSED

% Preallocate table to hold shape to add to table
entry = table('Size',[1 5],'VariableTypes',{'categorical','double','double','double','categorical'});
entry.Properties.VariableNames = {'Colour','Centroid','Circularity','Area','Shape'};
    
entry.Colour = shape_colour;
entry.Centroid = blobMeasurement.Centroid;
entry.Circularity = blobMeasurement.Circularity;
entry.Area = blobMeasurement.Area;

shapeLabel = shape_detect(blobMeasurement);
entry.Shape = shapeLabel;

end

%% Blue Mask
function [BW,maskedRGBImage] = blueMask(RGB)
%createMask  Threshold RGB image using auto-generated code from colorThresholder app.
%  [BW,MASKEDRGBIMAGE] = createMask(RGB) thresholds image RGB using
%  auto-generated code from the colorThresholder app. The colorspace and
%  range for each channel of the colorspace were set within the app. The
%  segmentation mask is returned in BW, and a composite of the mask and
%  original RGB images is returned in maskedRGBImage.

% Auto-generated by colorThresholder app on 12-Aug-2020
%------------------------------------------------------


% Convert RGB image to chosen color space
I = rgb2hsv(RGB);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.530;
channel1Max = 0.792;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.500;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.650;
channel3Max = 1.000;

% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;

% Initialize output masked image based on input image.
maskedRGBImage = RGB;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;

end

%% Red Mask
function [BW,maskedRGBImage] = redMask(RGB)
%createMask  Threshold RGB image using auto-generated code from colorThresholder app.
%  [BW,MASKEDRGBIMAGE] = createMask(RGB) thresholds image RGB using
%  auto-generated code from the colorThresholder app. The colorspace and
%  range for each channel of the colorspace were set within the app. The
%  segmentation mask is returned in BW, and a composite of the mask and
%  original RGB images is returned in maskedRGBImage.

% Auto-generated by colorThresholder app on 12-Aug-2020
%------------------------------------------------------


% Convert RGB image to chosen color space
I = rgb2hsv(RGB);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.864;
channel1Max = 0.126;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.500;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.650;
channel3Max = 1.000;

% Create mask based on chosen histogram thresholds
sliderBW = ( (I(:,:,1) >= channel1Min) | (I(:,:,1) <= channel1Max) ) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;

% Initialize output masked image based on input image.
maskedRGBImage = RGB;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;

end

%% Green Mask
function [BW,maskedRGBImage] = greenMask(RGB)
%createMask  Threshold RGB image using auto-generated code from colorThresholder app.
%  [BW,MASKEDRGBIMAGE] = createMask(RGB) thresholds image RGB using
%  auto-generated code from the colorThresholder app. The colorspace and
%  range for each channel of the colorspace were set within the app. The
%  segmentation mask is returned in BW, and a composite of the mask and
%  original RGB images is returned in maskedRGBImage.

% Auto-generated by colorThresholder app on 12-Aug-2020
%------------------------------------------------------


% Convert RGB image to chosen color space
I = rgb2hsv(RGB);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.234;
channel1Max = 0.496;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.500;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.650;
channel3Max = 1.000;

% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;

% Initialize output masked image based on input image.
maskedRGBImage = RGB;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;

end
