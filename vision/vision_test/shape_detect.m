function shape = shape_detect(circularity)

if circularity < 1.0
    shape = 'Circle';
  elseif circularity < 1.15
    shape = 'Pentagon';
  elseif circularity < 1.3
    shape = 'Rectangle';
  else
    shape = 'Triangle';
end
  
end