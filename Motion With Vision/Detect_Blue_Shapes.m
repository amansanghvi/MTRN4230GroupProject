load('Shape_Image_Labeler2.mat');
%gTruth.LabelDefinitions;
SquareGroundTruth = selectLabels(gTruth, 'Blue_Square');
trainingSquareData = objectDetectorTrainingData(SquareGroundTruth, 'SamplingFactor', 2);
acfDetector = trainACFObjectDetector(trainingSquareData, 'NegativeSamplesFactor',2);

I = imread('scene.jpg');
[bboxes,scores] = detect(acfDetector,I, 'Threshold',1);
%for i = 1:length(scores)
%   annotation = sprintf('Confidence = %.1f',scores(i));
%   I = insertObjectAnnotation(I,'rectangle',bboxes(i,:),annotation);
%end
%[~,idx] = scores(60);
annotation = acfDetector.ModelName;
I = insertObjectAnnotation(I,'rectangle',bboxes(12,:),annotation);

figure
imshow(I)