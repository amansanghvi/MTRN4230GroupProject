function label(numberOfObjects,circularities,blobMeasurements)

for blobNumber = 1 : numberOfObjects
    theLabel = shape_detect(circularities(blobNumber));
    text(blobMeasurements(blobNumber).Centroid(1), blobMeasurements(blobNumber).Centroid(2),...
        [theLabel ' [' num2str(blobMeasurements(blobNumber).Centroid(1),4) ' ' num2str(blobMeasurements(blobNumber).Centroid(2),4) ']'], 'Color', 'r');
end

end