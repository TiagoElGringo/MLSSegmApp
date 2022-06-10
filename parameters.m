function par = parameters(type)

switch type
    case "nregions"
        par.nlevels =5 ;
        par.l = transpose(0:10:10*(par.nlevels-1));
        par.lambda = ones(par.nlevels+1,1);
        %par.lambda(1) = 1;
        %par.lambda(end) = 1;
        %par.lambda
        par.nphi = 1;
        par.mu = 0.005;
        par.dt = 1;
        par.eps = 1.2;
        par.edgeStopType = "extremes";
        par.a = 10000;
        par.truncate = true;
        par.truncateval = -10;
        par.showevol = false;

    case "2regions"
        par.l=0;
        par.nphi = 1;
        par.lambda1 = 1;
        par.lambda2 = 1;
        par.mu = 1;%.015;
        par.dt = 1;%.05;

    case "multigeneral"
        par.nphi = 2;
        par.nlevels = 4;
        par.nlevelsperphi=par.nlevels/par.nphi;
        for i=1:par.nphi
            for j=2:par.nlevels
                par.l(i,:) = 0:10:10*(par.nlevelsperphi-1);
                par.lambda(i,:) = ones(par.nlevelsperphi+1,1);
            end
        end

   
        par.mu = .004;
        par.dt = 1;
        par.eps = 1;
        par.regtype = "length";
        par.a = 40000;
        par.truncate = true;
    case "multiphase-piecewise constant"
        par.nphi = 2;
        par.l = [0;0];
        par.mu = .005;
        par.dt = .05;
        par.lambda = [1; 1; 1; 1];
end

par.sigma = 1;
par.convThresh = 0.00;
par.nu = 0;
par.masktype = "multicircles";
par.kMax = 4;
%par.masktype = "circle";
%par.masktype = "rectangle";



end