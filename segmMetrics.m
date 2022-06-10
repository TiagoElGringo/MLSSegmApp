function metrics = segmMetrics(confusionMatAll)

precision = zeros(3,1);
recall = zeros(3,1);
accuracy = zeros(3,1);
IoU = zeros(3,1);
metrics.meanPrecision = zeros(size(confusionMatAll,3),1);
metrics.meanRecall = zeros(size(confusionMatAll,3),1);
metrics.meanAccuracy = zeros(size(confusionMatAll,3),1);
metrics.meanIoU = zeros(size(confusionMatAll,3),1);
metrics.GIoSD = zeros(size(confusionMatAll,3),1);
metrics.nGIoSD = zeros(size(confusionMatAll,3),1); 
metrics.SDoT = zeros(size(confusionMatAll,3),1);
metrics.precision = zeros(size(confusionMatAll,3),3);
metrics.recall = zeros(size(confusionMatAll,3),3);
metrics.accuracy = zeros(size(confusionMatAll,3),3);
metrics.IoU = zeros(size(confusionMatAll,3),3);

for i=1:size(confusionMatAll,3)
    confusionMat=confusionMatAll(:,:,i);
    for expected = 1:3

        P = sum(confusionMat(expected,:),'all');
        T = sum(confusionMat(:,expected),'all');
        TP = confusionMat(expected,expected);
        FP = P-TP;
        FN = T-TP;
        TN = sum(confusionMat,'all')-P-FN;

        
        if (TP==0)
            precision(expected) = 0;
            recall(expected) = 0;
            accuracy(expected) = 0;
            IoU(expected) = 0;
        else
            precision(expected) = TP/(TP+FN);
            recall(expected) = TP/(TP+FP);
            accuracy(expected) = (TP+TN)/(sum(confusionMat,'all'));
            IoU(expected) = TP/(TP+FP+FN);
        end
    end

    metrics.precision(i,:) = precision;
    metrics.recall(i,:) = recall;
    metrics.accuracy(i,:) = accuracy;
    metrics.IoU(i,:) = IoU;
    metrics.meanPrecision(i) = sum(precision,'all')/numel(precision);
    metrics.meanRecall(i) = sum(recall,'all')/numel(recall);
    metrics.meanAccuracy(i) = sum(accuracy,'all')/numel(accuracy);
    metrics.meanIoU(i) = sum(IoU,'all')/numel(IoU);

    maskWSF = [0 1 2;
               1 0 1;
               2 1 0];

    %maskWSF = [0 1 2;
    %           1 0 1;
    %           2 1 0];
    %metrics.GIoSD(i) = (trace(confusionMat)-confusionMat(1,1))/(trace(confusionMat)-confusionMat(1,1)+sum(maskWSF.*confusionMat,'all'));
    metrics.GIoSD(i) = trace(confusionMat)/(trace(confusionMat)+sum(maskWSF.*confusionMat,'all'));
    metrics.nGIoSD(i) = 2*trace(confusionMat)/(2*trace(confusionMat)+sum(maskWSF.*confusionMat,'all')); 

    metrics.SDoT(i) = sum(maskWSF.*confusionMat,'all')/(2*sum(confusionMat,'all'));
end 

metrics.globalPrecision = sum(metrics.meanPrecision,'all')/numel(metrics.meanPrecision);
metrics.globalRecall = sum(metrics.meanRecall,'all')/numel(metrics.meanRecall);
metrics.globalAccuracy = sum(metrics.meanAccuracy,'all')/numel(metrics.meanAccuracy);
metrics.globalIoU = sum(metrics.meanIoU,'all')/numel(metrics.meanIoU);
metrics.globalGIoSD = sum(metrics.GIoSD,'all')/numel(metrics.GIoSD);
metrics.globalnGIoSD = sum(metrics.nGIoSD,'all')/numel(metrics.nGIoSD);
metrics.globalSDoT = sum(metrics.SDoT,'all')/numel(metrics.SDoT);
end