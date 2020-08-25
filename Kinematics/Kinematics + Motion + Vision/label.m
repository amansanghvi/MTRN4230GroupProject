function label(numberOfObjects,blobMeasurements)

for blobNumber = 1 : numberOfObjects
    theLabel = shape_detect(blobMeasurements(blobNumber));
    text(blobMeasurements(blobNumber).Centroid(1), blobMeasurements(blobNumber).Centroid(2),...
        [theLabel ' [' num2str(blobMeasurements(blobNumber).Centroid(1),4) ' ' num2str(blobMeasurements(blobNumber).Centroid(2),4) ']'], 'Color', 'r');
end

end