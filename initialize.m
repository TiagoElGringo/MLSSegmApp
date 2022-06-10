function data = initialize(data)


%% scaling
g0=double(data.g0);
ScaleFactor = 255/max(g0(:));
g0 = g0.*ScaleFactor;
g0 = g0.*(g0<254);

g0 = imgaussfilt(g0, data.par.sigma);
data.g0=g0;
%% create multiple resolutions
data.par.kMax = 4;%round(log2(sum(size(g0)/100)/2));
data.res.k = data.par.kMax;
[data.g, data.gOffset] = create_multiple_resolutions(g0,data.res.k);
data.gcurr = data.g{data.res.k+1};

%% initial contour
switch data.par.nphi
    case 1
        data.mask = drawmaskasf(data.par.masktype, size(data.gcurr)); 
        data.phi = reinitialize(data.mask);
        data.phi_prev = data.phi;
        
    case 2
        for i=1:data.par.nphi
            data.mask = drawmaskasf(data.par.masktype, size(data.gcurr), i); 
            data.phi{i} = reinitialize(data.mask);
            data.phi_prev{i} = data.phi{i};
        end
end

data = calc_c(data);
%data = calc_reg_fcns(data);

data.count.steps = zeros(data.par.kMax+1,1);
data.count.it = zeros(data.par.kMax+1,1);

end