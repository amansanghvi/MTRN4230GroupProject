function label(numberOfObjects,circularities,blobMeasurements)

for blobNumber = 1 : numberOfObjects
  if circularities(blobNumber) < 1.19
    theLabel = 'Circle';
  elseif circularities(blobNumber) < 1.53
    theLabel = 'Rectangle';
  else
    theLabel = 'Triangle';
  end
  text(blobMeasurements(blobNumber).Centroid(1), blobMeasurements(blobNumber).Centroid(2),...
    [theLabel ' [' num2str(blobMeasurements(blobNumber).Centroid(1),4) ' ' num2str(blobMeasurements(blobNumber).Centroid(2),4) ']'], 'Color', 'r');
end

end