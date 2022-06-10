function data = calc_reg_fcns(data)

data.delta = {};
data.hvi = {};
eps=data.par.eps;

for i=1:size(data.l,1)
    delta{end+1} = 'pocrl';

end