function [labeledImage,numberOfObjects,blobMeasurements] = blob_detect(maskedImage)

[labeledImage,numberOfObjects] = bwlabel(maskedImage);
blobMeasurements = regionprops(labeledImage,'Perimeter','Area', 'Centroid','Circularity'); 
%circularities = [blobMeasurements.Perimeter].^2 ./ (4 * pi * [blobMeasurements.Area]);
end