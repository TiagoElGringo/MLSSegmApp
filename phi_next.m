function data = phi_next(data, mu)

fn=data.phi;
g=data.gcurr;
c=data.c;
iter=data.it.iter;
dt=data.par.dt;
par=data.par;
e=par.eps;

sigma=1;
G=fspecial('gaussian',1,sigma); % Caussian kernel
Img_smooth=conv2(g,G,'same');  % smooth image by Gaussiin convolution
[Ix,Iy]=gradient(Img_smooth);
f_edge=Ix.^2+Iy.^2;
edge_fcn=1./(1+f_edge);  % edge indicator function.

switch data.type
    case '2regions'
        
        WorkingClass = class(fn);  
        [nR,nC] = size(fn);

        Th_R = mu*abs_2layers(fn, 1); 
        Th_C = mu*abs_2layers(fn, 2);
       
        alpha = zeros(nR,nC, WorkingClass); 

        alpha(2:nR-1,:) = Th_R(1:nR-2,:) + Th_R(2:nR-1,:);   
        alpha(:,2:nC-1) = alpha(:,2:nC-1) + Th_C(:,1:nC-2) + Th_C(:,2:nC-1);    

        dirac=delta(e,fn+data.par.l);
        for i = 1:5

            beta = zeros(nR,nC, WorkingClass);
            
            beta(2:nR-1,:) = Th_R(1:nR-2,:).*fn(1:nR-2,:) + Th_R(2:nR-1,:).*fn(3:nR,:); % dX
            beta(:,2:nC-1) = beta(:,2:nC-1) + Th_C(:,1:nC-2).*fn(:,1:nC-2) + Th_C(:,2:nC-1).*fn(:,3:nC);  % dY
            %do fn, except borders
            residue = - par.lambda1.*(g-c(2)).^2 + par.lambda2.*(g-c(1)).^2 - par.nu;
        
            fn = (fn + (dirac*dt) .*(beta + residue)) ./ (1 + (dirac*dt) .* alpha);
            %borders and corners
            fn(:,1) = fn(:,2);
            fn(:,nC) = fn(:,nC-1);
            fn(1,:) = fn(2,:);
            fn(nR,:) = fn(nR-1,:);

            %figure(30);mesh(fn);
        end
        
    case "nregions"
        
        l=par.l;
        lambda=par.lambda;
        nlevels = size(l,1);

        %[C, length_term] = calc_reg_term(fn, par);
        
        WorkingClass = class(fn);  
        [nR,nC] = size(fn);

        Th_R = mu*abs_2layers(fn, 1); 
        Th_C = mu*abs_2layers(fn, 2);
       
        alpha = zeros(nR,nC, WorkingClass); 

        alpha(2:nR-1,:) = Th_R(1:nR-2,:) + Th_R(2:nR-1,:);   
        alpha(:,2:nC-1) = alpha(:,2:nC-1) + Th_C(:,1:nC-2) + Th_C(:,2:nC-1);    

        dirac=0;
        for a=1:size(l,1)
            dirac=dirac+delta(e,fn-l(a));
        end
            
        for i = 1:iter

            beta = zeros(nR,nC, WorkingClass);
            
            beta(2:nR-1,:) = Th_R(1:nR-2,:).*fn(1:nR-2,:) + Th_R(2:nR-1,:).*fn(3:nR,:); % dX
            beta(:,2:nC-1) = beta(:,2:nC-1) + Th_C(:,1:nC-2).*fn(:,1:nC-2) + Th_C(:,2:nC-1).*fn(:,3:nC);  % dY
        
            area_part = lambda(1).*delta(e,l(1)-fn).*(g-c(1)).^2;
            for i=2:nlevels
                area_part = area_part +lambda(i).*(...
                            + delta(e,l(i)-fn).*hvi(e,fn-l(i-1)).*(g-c(i)).^2 ... 
                            - delta(e,fn-l(i-1)).*hvi(e,l(i)-fn).*(g-c(i)).^2);
            end
            area_part = area_part - lambda(end).*delta(e,fn-l(nlevels)).*(g-c(nlevels+1)).^2;
            
            %area_part = area_part - 20000.*edge_fcn.*(...
            %                + delta(e,l(end)-fn).*hvi(e,fn-l(end-1)) ... 
            %                - delta(e,fn-l(end-1)).*hvi(e,l(end)-fn));
            
            if (par.edgeStopType == "inner")
                edgeStopType = par.a.*delta(e,fn-l(end)).*edge_fcn;
            elseif (par.edgeStopType == "all")
                edgeStopType = par.a/size(l,1).*dirac.*edge_fcn;
            elseif (par.edgeStopType == "extremes")
                edgeStopType = par.a/2.*(delta(e,fn-l(nlevels))+delta(e,fn-l(1))).*edge_fcn;
            end
            
            area_part = area_part - edgeStopType;
                        
            fn = (fn + (dirac*dt) .*(beta + area_part)) ./ (1 + (dirac*dt) .* alpha);
            
            
            %area_part = area_part - par.a.*delta(e,fn-l(end)).*edge_fcn;
            %area_part = area_part - par.a.*edge_fcn;
            
            %fn = (fn + (dirac*dt) .*(beta + area_part)) ./ (1 + (dirac*dt) .* alpha);
            
            %fn = 1./C.*(fn + (dt.*length_term) + dt.*area_part);
         
            % --- borders and corners
            fn(:,1) = fn(:,2);
            fn(:,end) = fn(:,end-1);
            fn(1,:) = fn(2,:);
            fn(end,:) = fn(end-1,:);

            if par.truncate == true
                fn = minvaluecheck(fn, par.truncateval);
            end
            
            if data.par.showevol
                imagesc(data.plotsegm,data.gcurr); 
                hold(data.plotsegm,"on");
                colormap(data.plotsegm,gray);
                colorarray = ['r'; 'g'; 'b'; 'y'; 'm'; 'c'; 'w'];
                for i=1:size(data.par.l,1)
                    contour(data.plotsegm,data.phi-data.par.l(i), [0 0], colorarray(i), 'LineWidth', .25,...
                        'DisplayName', num2str(round(data.c(i+1),0)));
                end
                hold(data.plotsegm,"off");
                lng = legend(data.plotsegm, 'show', 'Location', 'northeastoutside');
                %hLegend = findobj(gcf, 'Type', 'Legend');
                lng.ItemTokenSize = [10,30];
                lng.Color = [.6 .6 .6];
                lng.Title.String = ['Mean' newline 'intensities'];
            end
            %figure(30);mesh(fn);
        end
        
        
end
sigma=1;
G=fspecial('gaussian',1,sigma); % Caussian kernel
fn=conv2(fn,G,'same');  % smooth image by Gaussiin convolution
data.phi=fn;
%disp(norm(data.phi-data.phi_prev));
%disp(norm(data.phi-data.phi_prev)/norm(data.phi));
%disp('     ');
%data.phi_prev = fn; 
%figure(90);mesh(delta(e,data.phi))
%plotresults(data);
%aprox_image(data);
%figure(76);mesh(data.phi), hold on;
%title("Level Set Function");contour(data.phi-0, [0 0], 'r', 'LineWidth', 1);hold off;
%set(gca,'xticklabel',[]);
%set(gca,'yticklabel',[]);
%set(gca,'zticklabel',[]);
end

function Theta = abs_2layers(fn, dim) % old uDenominatorXY

if dim == 1
    df1p = finite_diff(fn, 'x', 'f');
    df2c = finite_diff(fn, 'y', 'c');
elseif dim == 2
    df1p = finite_diff(fn, 'y', 'f');
    df2c = finite_diff(fn, 'x', 'c');
end
    
Theta = df1p.^2 + df2c.^2/4;        % protection against division by 0
ix0 = (Theta==0);                   % crude: replace all 0's with
replacementVal = min(Theta(~ix0));  % the next minimum found in the
Theta(ix0) = replacementVal;        % denominator; smarter later
Theta = 1./sqrt(Theta);

end
