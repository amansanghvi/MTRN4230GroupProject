function entry = add_shapes(blobMeasurement,shape_colour)

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