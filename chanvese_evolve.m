function data = chanvese_evolve(data)

par=data.par;
 
g = data.gcurr;
k = data.res.k;
thisRange = (max(g(:))-min(g(:)))^2; 

% --- scale Miu depending on GData (initially uint8^2)
% and current scale (k) -> will+ as res+
thismu = par.mu * thisRange *2^(-k);
%thismu = par.mu * thisRange *2^(-k);
%thismu = data.par.mu * thisRange;
% it was 2^(-k) before, but now Fn is adjusted at Up /Down by 2 / 0.5

for i = 1:data.it.steps
    
    data = phi_next(data,thismu);
    
    data = calc_c(data);
   
    %if (norm(data.phi-data.phi_prev)/norm(data.phi))<par.convThresh
    %    disp(['stop at ' num2str(i) ' iterations']);
    %    data.phi_prev = data.phi;
    %    break;
    %end
    
    data.phi_prev = data.phi;
    %data = energy(data);
    
end

%data = aprox_image(data);

end
