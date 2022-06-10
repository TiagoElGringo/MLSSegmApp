function area_term = calc_area_term(fn, g, par, type)

c=par.c;
l=par.l;
lambda = par.lambda;
e=par.eps;

switch type

    case "nregions"
        area_term = lambda(1).*delta(e,l(1)-fn).*(g-c(1)).^2;
        for i=2:par.nlevels
            area_term = area_term +lambda(i).*(...
                        + delta(e,l(i)-fn).*hvi(e,fn-l(i-1)).*(g-c(i)).^2 ... 
                        - delta(e,fn-l(i-1)).*hvi(e,l(i)-fn).*(g-c(i)).^2);
        end
        area_term = area_term - lambda(end).*delta(e,fn-l(end)).*(g-c(end)).^2;

    case ""

        if i==1
            l=L(1,:);
            k=L(2,:);
            f = 1./C.*(f + (m1.*soma) + dt.*(...
                lambda(1)*(g-c(1,1)).^2.*delta(e,l(1)-fn{1}).*hvi(e,k(1)-fn{2})...
                +lambda(2)*(g-c(1,2)).^2.*delta(e,l(1)-fn{1}).*hvi(e,fn{2}-k(2))...
                -lambda(3)*(g-c(2,1)).^2.*delta(e,fn{1}-l(2)).*hvi(e,k(1)-fn{2})...
                -lambda(4)*(g-c(2,2)).^2.*delta(e,fn{1}-l(2)).*hvi(e,fn{2}-k(2))));
        elseif i==2
            l=L(1,:);
            k=L(2,:);
            f = 1./C.*(f + (m1.*soma) + dt.*(...
                lambda(1)*(g-c(1,1)).^2.*delta(e,k(1)-fn{2}).*hvi(e,l(1)-fn{1})...
                -lambda(2)*(g-c(1,2)).^2.*delta(e,fn{2}-k(2)).*hvi(e,l(1)-fn{1})...
                +lambda(3)*(g-c(2,1)).^2.*delta(e,k(1)-fn{2}).*hvi(e,fn{1}-l(2))...
                -lambda(4)*(g-c(2,2)).^2.*delta(e,fn{2}-k(2)).*hvi(e,fn{1}-l(2))));
        end


end