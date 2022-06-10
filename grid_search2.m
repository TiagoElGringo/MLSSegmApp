%% initialize
clear all;
%close all;
clc;

data.confusionMatrix = [];
data.results.nome = {};
data.results.alpha = [];
data.results.mu = [];
data.results.eps = [];
data.results.sigma = [];
data.results.ncontours = [];
data.results.selected = [1,2];
data.results.time = [];
data.results.clenTotal = [];
data.metrics = {};
data.results.clen = [];
data.results.cnum = [];

j=1;

for sequence = 1:3
%sequence = 1;

if sequence == 1
    imagesIDs = 34:24:687;
    %imagesIDs = 610;
elseif sequence == 2
    imagesIDs = 21:24:453;
elseif sequence == 3
    imagesIDs = 71:24:251;
end
%imagesIDs = 34;

sq = num2str(sequence);

alpha_vec =0000:10000:100000; %6
mu_vec = 0.001:0.001:0.01; %4
sigma_vec = 1; %3

%alpha_vec = 50000;
%mu_vec = 0.005;
%data.metrics = zeros(size(mu_vec,2), size(alpha_vec,2));
%data.results.clen = zeros(nlevels_vec,size(mu_vec,2), size(alpha_vec,2));

sessions_path = 'D:\5 ano 2 S\Tese\labelling session';
video_path = '\video fogo_1';
sequence_path = ['\sequence ' sq];

session_file = ['\imageLabelingSession_fogo1_' sq '.mat'];
gtruth_path = ['\.imageLabelingSession_fogo1_' sq '_SessionData'];

%load labelling session
load([sessions_path video_path sequence_path session_file]);

gtruthIDvec = extractBetween(imageLabelingSession.ImageFilenames(1:end),'fogo_1 ','.png');

for i=1:size(imagesIDs,2)

image_type = '.png';

%image_path = 'D:\5 ano 2 S\Tese\Datasets\videos\videos\Lousa\10set20 - Evento Ourém\imagens 24fps UAFAP1VIDEO_1 0SET18\';
image_path = ['D:\5 ano 2 S\Tese\Datasets\Imagens Video FOGO_1 30fps\sequence ' sq '\'];
nome = getname(imagesIDs(i));
image_name = ['fogo_1 ' nome];

input_image = [image_path image_name image_type];

type = "nregions";

data.g0 = [];
data.type = type;
data.it = iterations();
data.par = parameters(type);

%data.g0 = double(imread(input_image));
data.I = imread(input_image);
data.g0 = pre_process(data.I);
data.I=data.g0;

tic;

figure(1);imagesc(data.g0);title('Original image');colormap(gray);

data=initialize(data);
pos = find(strcmp(gtruthIDvec, nome));

gtruth = imread([sessions_path video_path sequence_path gtruth_path '\Label_' num2str(pos) '.png']);
gtruth = double(gtruth+1);

for a=1:size(sigma_vec,2)
   for b=1:size(mu_vec,2) 
       for c=1:size(alpha_vec,2)
           %% main cycle
            data.type = type;
            data.it = iterations();
            data.par = parameters(type);
            data.par.nlevels = 5;
            data.par.l = transpose(0:10:10*(data.par.nlevels-1));
            data.par.lambda = ones(data.par.nlevels+1,1);
            data.par.sigma = sigma_vec(a);
            data.par.mu = mu_vec(b);
            data.par.a = alpha_vec(c);
            data.par.truncate = true;
            data.res.k = data.par.kMax;
            data.gcurr = data.g{data.res.k+1};
            tic;
            data.mask = drawmaskasf(data.par.masktype, size(data.gcurr)); 
            data.phi = reinitialize(data.mask);
            data = calc_c(data);
            data.count.steps = zeros(data.par.kMax+1,1);
            data.count.it = zeros(data.par.kMax+1,1);
            data = standard(data);
            
            data.results.time(end+1) = toc;
            %data = plotresults(data);
            %data = plot_energy(data);
            %data = aprox_image(data);
            data = build_mask(data);
            disp(image_name);
            
            mask=data.mask;
            
            mask = double(mask+1);

            
            confMat = confusionMatrix(gtruth, mask); 
            data.confusionMatrix(:,:,b,c,j) = confMat;
            %[clen, cnum] = getContoursLength(data);
            %data.results.clen(:,b,c,end+1) = clen;
            %data.results.cnum(:,b,c,end+1) = cnum;
            
            data.results.nome{end+1} = image_name;
            data.results.alpha(end+1) = data.par.a;
            data.results.mu(end+1) = data.par.mu;
            data.results.eps(end+1) = data.par.eps;
            data.results.sigma(end+1) = data.par.sigma;
            data.results.ncontours(end+1) = data.par.nlevels;
            %data.results.GIoSD(end+1) = GIoSD; 
            %data.results.nGIoSD(end+1) = nGIoSD;
            
            data.c=[];
            data.phi=[];
           
       end
   end
end
j=j+1;
end

end

%confusionMatrixaux = data.confusionMatrix(:,:,:,:,2:end);

for b=1:size(mu_vec,2) 
   for c=1:size(alpha_vec,2)
        metrics = segmMetrics(squeeze(data.confusionMatrix(:,:,b,c,:)));
        data.metrics{b,c} = metrics;
        %data.results.clenTotal = sum(data.results.clen(:,b,c),'all')/55; 
   end
end


%{
results = zeros(size(data.metrics));
for i=1:size(data.metrics,1)
    for j=1:size(data.metrics,2)
        results(i,j) = data.metrics{i,j}.globalIoU;
    end
end
results(:,end-3:end)=results(:,end-3:end)-0.01
results(:,end-2:end)=results(:,end-2:end)-0.01
results(:,end)=results(:,end)-0.01
figure(1);mesh(results);
a=gca;
a.XTickLabel=[{'0'};{}] 

%}