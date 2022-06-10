function data = standard(data)
    data.it.steps = data.it.stepsvec(data.par.kMax+1);
    data.it.iter = data.it.itervec(data.par.kMax+1);
    for i = data.par.kMax:-1:1
        data = chanvese_evolve(data);
        data = change_resolution_phi(data, 1);
        disp(['k is now ' num2str(data.res.k)]);
        data.it.iter = data.it.itervec(i);
        data.it.steps=data.it.stepsvec(i);
    end
    data = chanvese_evolve(data);
    
    %data = getContoursLength(data);
end