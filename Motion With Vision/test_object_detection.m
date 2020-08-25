% Object detection v2
% z5116787, Jason Phu
% for MTRN4230 Group assignment, T2.2020
%
% Provide image and code will supply table with all shapes and their
% colours and locations

function shapes = test_object_detection(image, fig,tab_fig)
% Timing
tic

% Change this for option to show the figure ui of detected images and the
% table showing all detected objects and properties
show_ui = 1;

    %% Read in images

    % If no image passed through, use default file (for testing only)
    if ~exist('image','var')
        scene = imread('world.png');
    else
        scene = image;
    end

    %scene = imresize(scene,1.5);
    %scene = imclearborder(scene,8);
    if show_ui
        % Show original image
        %fig.WindowState = 'Maximized';
        set(0,'CurrentFigure',fig);
        scenePlot = subplot(2,2,1);
        imshow(scene);
        title('Original Image');
    end

    %% Process images to mask colours

    % Mask each colour
    redMasked = redMask(scene);
    %redMasked = imclearborder(redMasked);
    greenMasked = greenMask(scene);
    %greenMasked = imclearborder(greenMasked);
    blueMasked = blueMask(scene);
    %blueMasked = imclearborder(blueMasked);

    % Do a small erode open to remove noise
    redMasked = imerode(redMasked,strel('disk',2));
    greenMasked = imerode(greenMasked,strel('disk',2));
    blueMasked = imerode(blueMasked,strel('disk',2));

    %% Process to detect shapes and fill table
    
    % Preallocate table to hold shapes
    shapes = table('Size',[0 5],'VariableTypes',{'categorical','double','double','double','categorical'});
    shapes.Properties.VariableNames = {'Colour','Centroid','Circularity','Area','Shape'}; % First value of centroid is horizontal coordinate, second is vertical coordinate

    % Label objects of red colour and find region properties
    [labeledImage,numberOfObjects,blobMeasurements] = blob_detect(redMasked);
    col = 'Red';

    if show_ui
        % Show mask of red shapes
        redMaskedPlot = subplot(2,2,2);
        imshow(redMasked);
        title('Red objects');
        label(numberOfObjects,blobMeasurements);
    end

    % Add to table
    for i = 1:size(blobMeasurements,1)
        shapes = [shapes;add_shapes(blobMeasurements(i),col);];
    end

    % Label objects of green colour and find region properties
    [labeledImage,numberOfObjects,blobMeasurements] = blob_detect(greenMasked);
    col = 'Green';

    if show_ui
        % Show mask of green shapes
        greenMaskedPlot = subplot(2,2,3);
        imshow(greenMasked);
        title('Green objects');
        label(numberOfObjects,blobMeasurements);
    end

    % Add to table
    for i = 1:size(blobMeasurements,1)
        shapes = [shapes;add_shapes(blobMeasurements(i),col);];
    end

    % Label objects of blue colour and find region properties
    [labeledImage,numberOfObjects,blobMeasurements] = blob_detect(blueMasked);
    col = 'Blue';

    if show_ui
        % Show mask of blue shapes
        blueMaskedPlot = subplot(2,2,4);
        imshow(blueMasked);
        title('Blue objects');
        label(numberOfObjects,blobMeasurements);
    end

    % Add to table
    for i = 1:size(blobMeasurements,1)
        shapes = [shapes;add_shapes(blobMeasurements(i),col);];
    end

    %saveas(gcf,'analysis.png');
    %shapes_table = shapes;

    %% Create and display table with information on all detected objects

    if show_ui
        %uitab = uifigure;
        %uit = uitable(uitab);
        %uit.Data = shapes;
        %uit.ColumnSortable = [true false true true true];
        %uit.Position = [15 15 500 400];
    end

    %% Get statistics on the analysed image - categorical

    % Show data summary for colours and shapes
    %shapes_summary = summary(shapes);

    % cat_count = table('Size',[4 3],'VariableTypes',{'uint8','uint8','uint8'});
    % cat_count.Properties.VariableNames = {'Red','Green','Blue'};
    % cat_count.Properties.RowNames = {'Rectangle','Circle','Triangle','Pentagon'};

    % cat_count({'Rectangle'},{'Blue'}) = sum(shapes.Colour == 'Blue' & shapes.Shape == 'Rectangle')

% Timing
toc
end