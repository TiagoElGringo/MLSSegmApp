function data = energy(data)

par=data.par;
f=data.phi;
g = data.gcurr;
c = data.c;
l=par.l;
e=par.eps;

energy = 0;

switch data.type
    
    case "2regions"
        
        gradx = .5*finite_diff(f, 'c', 'x');
        grady = .5*finite_diff(f, 'c', 'y');
        gradmod = (gradx.^2 + grady.^2).^(1/2);
        energy = par.mu.*sum(delta(f).*gradmod, 'all')+...
                 par.nu*sum(hvi(e,f+l),'all')+...
                 par.lambda1*sum((g-c(1)).^2.*hvi(e,f+l),'all') + ...
                 par.lambda2*sum((g-c(2)).^2.*hvi(e,l-f),'all');
             
    case "nregions"
        
        area_energy = sum((g-c(1)).^2.*hvi(e,l(1)-f),"all");
        for i=2:par.nlevels
            area_energy = area_energy + sum((g-c(i)).^2.^hvi(e,f-l(i-1).*hvi(e,l(i)-f)),"all");
        end
        area_energy = area_energy + sum((g-c(end)).^2.*hvi(e,f-l(end)),"all");
        
        length_energy = 0;
        for i=1:par.nlevels
            gradx = .5.*finite_diff(hvi(e,f-l(i)), 'x', 'c');
            grady = .5.*finite_diff(hvi(e,f-l(i)), 'x', 'c');
            gradmod = (gradx.^2 + grady.^2).^(1/2);
            length_energy = length_energy + sum(gradmod, "all");
        end
        
        energy_gradinnerlayer = par.a.*sum(g.*hvi(e,l(end)-f), "all");
        
        energy = area_energy + par.mu.*length_energy + energy_gradinnerlayer;
        
        if data.energy.total(1)==-1
            data.energy.area(1) = area_energy;
            data.energy.length(1) = length_energy;
            data.energy.gradinnerlayer(1) = energy_gradinnerlayer;
            data.energy.total(1) = area_energy + length_energy + energy_gradinnerlayer;
        else
            data.energy.area(end+1) = area_energy;
            data.energy.length(end+1) = length_energy;
            data.energy.gradinnerlayer(end+1) = energy_gradinnerlayer;
            data.energy.total(end+1) = area_energy + length_energy + energy_gradinnerlayer;
        end
        
        
        
end

end