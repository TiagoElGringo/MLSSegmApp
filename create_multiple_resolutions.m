function [g, G_isodd_dim] = create_multiple_resolutions(g0, kMax)

G_isodd_dim = []; 

g{1} = g0; clear g0;

G_isodd_dim = zeros(kMax,2);
for i = 2:kMax+1
    [nR, nC] = size(g{i-1});
    G_isodd_dim(i-1,:) = mod([nR nC],2); % offsets used in Fn Multi-Scale
    ixR = 1:2:nR; ixC = 1:2:nC;
    nextSmSlice = interp2(g{i-1}, ixC, ixR', 'spline'); %spline
    g{i} = nextSmSlice; 
end
end