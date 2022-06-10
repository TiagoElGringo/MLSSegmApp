function data = aprox_image(data)

par=data.par;
f=data.phi;
g = data.gcurr;
c = data.c;
l=par.l;
e=par.eps;

switch data.type
    
    case "2regions"
        
        g_ap = c(1).*hvi(e,-f) + c(2).*hvi(e,f);
               
    case "nregions"
        
        g_ap = c(1).*hvi(e,l(1)-f) + c(end).*hvi(e,f-l(end));
        for i=2:par.nlevels
           g_ap = g_ap + c(i).*hvi(e,f-l(i-1)).*hvi(e,l(i)-f); 
        end
            
        
end

c_string = strjoin(string(num2str(round(c,2))));

data.fig.aprox = figure(23);
imagesc(g_ap, [0 255]);colormap(gray);
%title(['Aprox. c: ' c_string]);
title('Segmentation mask');
end