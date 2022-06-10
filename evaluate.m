function [IOUvec,avg] = evaluate()


sessions_path = 'D:\5 ano 2 S\Tese\labelling session';
video_path = '\video fogo_1';
sequence_path = '\sequence 1';

session_file = '\imageLabelingSession_fogo1_1.mat';
gtruth_path = '\.imageLabelingSession_fogo1_1_SessionData';

masks_path = 'D:\5 ano 2 S\Tese\Matlab\My_algorithms\app\Functions\Masks';

%load labelling session
load([sessions_path video_path sequence_path session_file]);

%load gtruth masks file names
files = dir([sessions_path video_path sequence_path gtruth_path '\*.png']);

%{
gtruthfilesnames = strings(55,1);
for i=1:size(files,1)
    gtruthfilesnames(i,1) = files(i).name;
end
gtruthfilesnames = sort(gtruthfilesnames);
%}

IOUvec = zeros(size(files));

for i=1:size(files,1)

    gtruth = imread([sessions_path video_path sequence_path gtruth_path '\Label_' num2str(i) '.png']);
    
    imageid = char(extractBetween(imageLabelingSession.ImageFilenames(i),'fogo_1 ','.png'));
    load([masks_path sequence_path '\fogo_1 ' imageid '_mask.mat']);
    
    seg=uint8(mask);clear mask;
    
    seg(seg<=1)=0;
    seg(seg>=1&seg<=5)=1;
    seg(seg==6)=2;
    
    %TP = sum(seg==maskid & seg==gtruth, 'all'); %true positive
    %FP = sum(seg==maskid & gtruth~=maskid, 'all'); %false positive
    %FN = sum(seg~=maskid & gtruth==maskid, 'all'); %false negative

    %IOU=TP/(TP+FP+FN);

    union = seg~=0|gtruth~=0;
    diff = abs(seg-gtruth);
    TP = sum(diff==0 & union~=0, 'all');
    TP=TP;
    FPandFN = sum(diff,'all');
    alt_IOU=TP/(TP+FPandFN);
    
    IOUvec(i,1)=alt_IOU;

    avg = sum(IOUvec(:))/size(IOUvec,1);
    
end




%}


end