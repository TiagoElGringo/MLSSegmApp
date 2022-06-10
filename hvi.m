function Hvi = hvi(eps,f)
%eps=1;
%Hvi=.5+1/pi*(atan(f/eps));
Hvi=.5+1/pi*(atan2(f,eps));
%Hvi=double(f>0);
%Hvi(f<-eps)=0;
%Hvi(f>eps)=0;
end

 