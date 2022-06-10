function div = calc_div(f)

f_x = .5*finite_diff(f,'x','c');
f_y = .5*finite_diff(f,'y','c');
f_xx = finite_diff(f,'xx','c');
f_yy = finite_diff(f,'yy','c');
f_xy = finite_diff(f,'xy','c');

den = (f_x.^2 + f_y.^2).^(2);        % protection against division by 0
ix0 = (den==0);                   % crude: replace all 0's with
replacementVal = min(den(~ix0));  % the next minimum found in the
den(ix0) = replacementVal;        % denominator; smarter later
div = (f_xx.*f_y.^2 - 2.*f_x.*f_y.*f_xy + f_yy.*f_x.^2)./den;
end