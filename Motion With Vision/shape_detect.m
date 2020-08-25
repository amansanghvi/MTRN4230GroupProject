function shape = shape_detect(blobMeasurement)

n = blobMeasurement.Area;
k = blobMeasurement.Circularity;

if n < 1000
        shape = 'Triangle';
    elseif n < 1850 && k > 0.9
        shape = 'Circle';
    elseif n < 2200 && k > 0.8
        shape = 'Pentagon';
    elseif n < 3500
        shape = 'Square';
else
    shape = 'Invalid';
end
  
end