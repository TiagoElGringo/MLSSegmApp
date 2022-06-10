function Dirac = delta(eps,f)
%eps=1;
%max = eps/pi;
Dirac = eps./(pi*(eps.^2+(f).^2));
%Dirac = 1./(eps.^2+(f).^2);
%Dirac(f<-eps)=0;
%Dirac(f>eps)=0;
end