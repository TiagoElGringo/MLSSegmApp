%function main_chan_vese_all(n_image)

%% initialize
%clear all;
close all;
clc;

image_path = 'D:\5 ano 2 S\Tese\Matlab\histograms\ImagesBWNT\';
%image_name = ['NT_' num2str(n_image)];
image_name = 'NT_1';
%}
image_type = '.png';

image_path = 'D:\5 ano 2 S\Tese\Datasets\Imagens Video FOGO_1 30fps\sequence 1\';
image_name = 'fogo_1 00034';

%image_path = 'D:\5 ano 2 S\Tese\Datasets\videos\videos\Lousa\10set20 - Evento Ourém\imagens 24fps UAFAP1VIDEO_1 0SET18\';
%nome = getname(n_image);
%image_name = ['0SET18 ' nome];
%image_name = '0SET18 00001';

dest_path = 'D:\5 ano 2 S\Tese\Matlab\My_algorithms\Chan-Vese\results\';
dest_image = [image_name '_segmented'];

input_image = [image_path image_name image_type];
output_image = [dest_path dest_image];

type = "2regions";
type = "nregions";
%type = "multigeneral";
%type = "multiphase-piecewise constant";
%type = "3regions2fn"; %Yang2011
%type = "2fnnregions";
data = construct_data(type);

%data.g0 = double(imread(input_image));
data.I = imread(input_image);
data.g0 = pre_process(data.I);
data.I=data.g0;

tic;

data.fig.original=figure(1);imagesc(data.g0);title('Original image');colormap(gray);
data = initialize(data);
%% main cycle
%prompt = '\nStandard? [0]\n';
%x = input(prompt);
x=0;
if x == 0 
    data = standard(data);
    data = watershed_segm(data);
    
    data.time = toc;
    data = plotresults(data);
    data = plot_energy(data);
    %data = aprox_image(data);
    data = build_mask(data);
    disp(image_name);
    
    dir = 'Video/';

    %saveas(data.fig.original,[dir image_name '_0riginal time=' num2str(data.time) '.png']);
    %saveas(data.fig.segmentation,[dir image_name '_1segmentation' '.png']);
    %saveas(data.fig.aprox,[dir image_name '_2aproximation' '.png']);
    %saveas(data.fig.energy,[dir image_name '_3energy' '.png']);
    mask=data.mask;
    %save(['Masks/' image_name '_mask'], 'mask');

    clear;
    close all;
%}
    return;
 
end
        
while(1)
prompt = '\nAction?\n[1] Iter\n[2] Resize\n[3] Change iter\n[4] Save & Exit\n';
x = input(prompt);

switch x
    
    case 1
        data.it.steps = data.it.stepsvec(data.res.k+1);
        data.it.iter = data.it.itervec(data.res.k+1);
        data = chanvese_evolve(data);
        
    case 2
        prompt = '\nUp or Down?\n[1] Up\n[2] Down\n';
        y = input(prompt);
        
        switch y
            case 1
                data = change_resolution_phi(data, 1);
            case 2
                data = change_resolution_phi(data, 0);
            otherwise
                disp('wrong choice');
                continue;
        end
        
        disp(['k is now ' num2str(data.res.k)]);
        
    case 3
        disp(['Current: steps=' num2str(data.it.steps) ' iter/step=' num2str(data.it.iter)]);
        
        newsteps = input('New value steps? ');
        if ~isempty(newsteps)
            data.it.stepsvec(data.res.k+1) = newsteps;
        end
        
        newiter = input('New value iter? ');
        if ~isempty(newiter)
            data.it.itervec(data.res.k+1) = newiter;
        end
        
        disp(['New: steps=' num2str(data.it.stepsvec(data.res.k+1)) ' iter/step=' num2str(data.it.itervec(data.res.k+1))]);
        
        newdt = input('New value dt? ');
        if ~isempty(newdt)
            data.par.dt = newdt;
        end
        
        disp(['New: dt=' num2str(data.par.dt)]);
        
    case 4

        return;
        
    otherwise
        disp('wrong choice');
        continue;
        
end

plotresults(data);

end

%end
%{
x=-10:0.00001:10;
eps=[0.00001 1 1.5];
figure(1);
plot(x,delta(eps(1),x),'linewidth',1);hold on;
plot(x,delta(eps(2),x),'linewidth',1);
plot(x,delta(eps(3),x),'linewidth',1);hold off;
legend(['\epsilon=0'],['\epsilon=' num2str(eps(2))],['\epsilon=' num2str(eps(3))]);
title('Dirac regularized function \delta_{\epsilon}(x)')
ylabel('\delta_{\epsilon}(x)')
xlabel('x')
xlim([-10 10])
ylim([-.025 0.35])
%}
