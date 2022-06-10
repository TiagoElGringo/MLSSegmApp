function gradmod = calc_gradmod(fn)

gradx = .5*finite_diff(fn, 'c', 'x');
grady = .5*finite_diff(fn, 'c', 'y');
gradmod = (gradx.^2 + grady.^2).^(1/2);

end