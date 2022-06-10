%function grid_search()

%% initialize
clear all;
close all;
clc;

sequence = 2;

if sequence == 1
    imagesIDs = 34:24:687;
elseif sequence == 2
    imagesIDs = 21:24:453;
elseif sequence == 3
    imagesIDs = 71:24:251;
    %imagesIDs = 155;
end
%imagesIDs = 34;

sq = num2str(sequence);

alpha_vec =0000:10000:100000; %6
mu_vec = 0.001:0.001:0.015; %4
sigma_vec = 2; %3

nlevels_vec = 5;

%alpha_vec = 30000;
%mu_vec = 0.003;

sessions_path = 'D:\5 ano 2 S\Tese\labelling session';
video_path = '\video fogo_1';
sequence_path = ['\sequence ' sq];

session_file = ['\imageLabelingSession_fogo1_' sq '.mat'];
gtruth_path = ['\.imageLabelingSession_fogo1_' sq '_SessionData'];

%load labelling session
load([sessions_path video_path sequence_path session_file]);

gtruthIDvec = extractBetween(imageLabelingSession.ImageFilenames(1:end),'fogo_1 ','.png');

data.results.nome = {};
data.results.alpha = [];
data.results.mu = [];
data.results.eps = [];
data.results.sigma = [];
data.results.ncontours = [];
data.results.selected = [2,5];
data.results.IOU = [];
data.results.time = [];

for i=1:size(imagesIDs,2)
%image_path = 'D:\5 ano 2 S\Tese\Datasets\videos\videos\Lousa\10set20 - Evento Ourém\imagens 24fps UAFAP1VIDEO_1 0SET18\';
%image_name = ['NT_' num2str(n_image)];
%image_name = 'NT_1';
%}
image_type = '.png';

%image_path = 'D:\5 ano 2 S\Tese\Datasets\videos\videos\Lousa\10set20 - Evento Ourém\imagens 24fps UAFAP1VIDEO_1 0SET18\';
image_path = ['D:\5 ano 2 S\Tese\Datasets\Imagens Video FOGO_1 30fps\sequence ' sq '\'];
nome = getname(imagesIDs(i));
image_name = ['fogo_1 ' nome];

%dest_path = 'D:\5 ano 2 S\Tese\Matlab\My_algorithms\Chan-Vese\results\';
%dest_image = [image_name '_segmented'];

input_image = [image_path image_name image_type];
%output_image = [dest_path dest_image];

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
            data.par.truncate = false;
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

            %dir = ['ourem results/' num2str(nlevels_vec(a)) ' levels/'];
            %dir_masks = ['ourem results/Masks/' num2str(nlevels_vec(a)) ' levels/'];
            
            %savename = [image_name '_mu' num2str(mu_vec(b)*1000) 'E-3' '_a' num2str(alpha_vec(c)/1000) 'E3']; 

            %saveas(data.fig.original,[dir image_name '_0riginal time=' num2str(data.time) '.png']);
            %saveas(data.fig.segmentation,[dir savename '.png']);
            %saveas(data.fig.aprox,[dir image_name '_2aproximation' '.png']);
            %saveas(data.fig.energy,[dir image_name '_3energy' '.png']);
            mask=data.mask;
            %save([dir_masks savename], 'mask');
            
            %figure(22);imshowpair(mask,gtruth,'montage');
            
            mask = double(mask);
            gtruth = double(gtruth);
            union = mask~=0|gtruth~=0;
            diff = abs(mask-gtruth);
            TP = sum(diff==0 & union~=0, 'all');
            TP=TP;
            FPandFN = sum(diff,'all');
            alt_IOU=TP/(TP+FPandFN);
            
            data.results.nome{end+1} = image_name;
            data.results.alpha(end+1) = data.par.a;
            data.results.mu(end+1) = data.par.mu;
            data.results.eps(end+1) = data.par.eps;
            data.results.sigma(end+1) = data.par.sigma;
            data.results.ncontours(end+1) = data.par.nlevels;
            data.results.IOU(end+1) = alt_IOU; 
            
            data.c=[];
            data.phi=[];
            
            

           
       end
   end
end

end
%end