function [IOU, alt_IOU] = calculate_IOU(seg, contour, gtruth)

switch contour
    case 'inner'
        maskid = 3;
    case 'outer'
        maskid = 1;    
    case 'mid'
        maskid=2;
end

TP = sum(seg==maskid & seg==gtruth, 'all'); %true positive
FP = sum(seg==maskid & gtruth~=maskid, 'all'); %false positive
FN = sum(seg~=maskid & gtruth==maskid, 'all'); %false negative

IOU=TP/(TP+FP+FN);

union = seg~=0|gtruth~=0;
diff = abs(seg-gtruth);
TP = sum(diff==0 & union~=0, 'all');
TP=TP;
FPandFN = sum(diff,'all');
alt_IOU=TP/(TP+FPandFN);


end