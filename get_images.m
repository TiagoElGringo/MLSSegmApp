clear;
close all;
clc;

image_path = 'D:\5 ano 2 S\Tese\Matlab\histograms\ImagesBWNT\';
image_type = '.png';

dir = 'D:\5 ano 2 S\Tese\ImagensTese\';

%output_image = [dest_path dest_image];

type = "nregions";

for contour = 1:6
   
for n_image = 1:17    
    image_name = ['NT_' num2str(n_image)];
    input_image = [image_path image_name image_type];

    data = construct_data(type);
    data.par.nlevels = contour;
    data.par.l = transpose(0:10:10*(data.par.nlevels-1));
    data.par.lambda = ones(data.par.nlevels+1,1);
    %data.g0 = double(imread(input_image));
    data.I = imread(input_image);
    data.g0 = pre_process(data.I);
    data.I=data.g0;
    data = initialize(data);
    data = standard(data);
    
    data = plotresults(data);
    data = aprox_image(data);
    %data = build_mask(data);
    disp(image_name);
    disp(data.par.nlevels);
    
    %dir = 'Video/';

    %saveas(data.fig.original,[dir image_name '_0riginal time=' num2str(data.time) '.png']);
    saveas(data.fig.segmentation,[dir image_name '_segm' num2str(data.par.nlevels) '.png']);
    saveas(data.fig.aprox,[dir image_name '_aprox' num2str(data.par.nlevels) '.png']);
    %saveas(data.fig.energy,[dir image_name '_3energy' '.png']);
    mask=data.mask;
    %save(['Masks/' image_name '_mask'], 'mask');

    close all;
 
end
end