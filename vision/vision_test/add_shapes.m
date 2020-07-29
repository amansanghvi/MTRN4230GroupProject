function entry = add_shapes(blobMeasurement,shape_colour)

% Preallocate table to hold shape to add to table
entry = table('Size',[1 4],'VariableTypes',{'categorical','double','double','categorical'});
entry.Properties.VariableNames = {'Colour','Centroid','Circularity','Shape'};
    
entry.Colour = shape_colour;
entry.Centroid = blobMeasurement.Centroid;

circularity = [blobMeasurement.Perimeter].^2 ./ (4 * pi * [blobMeasurement.Area]);
if circularity < 1.0
	shapeLabel = 'Circle';
elseif circularity < 1.1
    shapeLabel = 'Pentagon';
elseif circularity < 1.3
	shapeLabel = 'Rectangle';
else
    shapeLabel = 'Triangle';
end

entry.Circularity = circularity;
entry.Shape = shapeLabel;

end