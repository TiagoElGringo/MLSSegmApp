function data = construct_data(type)

data.g0 = [];
data.type = type;
data.it = iterations();
data.par = parameters(type);

data.energy.area = -1;
data.energy.length = -1;
data.energy.gradinnerlayer = -1;
data.energy.total = -1;


end
