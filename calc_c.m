function data = calc_c(data) 

f=data.phi;
g=data.gcurr;
l=data.par.l;
e=data.par.eps;

switch data.type
            
    case "nregions"
        nlevels = data.par.nlevels;
        c=zeros(nlevels+1,1);
        c(1)=sum(g.*hvi(e,l(1)-f),'all')/sum(hvi(e,l(1)-f),'all'); %outside
        for i=2:nlevels
           c(i)=sum(g.*hvi(e,f-l(i-1)).*hvi(e,l(i)-f),'all')/sum(hvi(e,f-l(i-1)).*hvi(e,l(i)-f),'all');
        end
        c(nlevels+1)=sum(g.*hvi(e,f-l(nlevels)),'all')/sum(hvi(e,f-l(nlevels)),'all'); %inside
                
    case "2regions"
        c=zeros(2,1);
        c(2)=sum(g.*hvi(e,f+l),'all')/sum(hvi(e,f+l),'all'); %inside
        c(1)=sum(g.*hvi(e,l-f),'all')/sum(hvi(e,l-f),'all'); %outside
        %c(2)=sum(g.*hvi(e,f),'all')/sum(hvi(e,f),'all'); %inside
        %c(1)=sum(g.*hvi(e,-f),'all')/sum(hvi(e,-f),'all'); %outside
        
end

data.c=c;
%c
end

