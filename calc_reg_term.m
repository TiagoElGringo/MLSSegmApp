function [C, reg_term] = calc_reg_term(fn,par)

l=par.l;
mu=par.mu;
e=par.eps;

C1 = abs_multigeneral(fn, 1);  
C2 = abs_multigeneral(fn, 2);
C3 = abs_multigeneral(fn, 3);
C4 = abs_multigeneral(fn, 4);

div = zeros(size(fn));

switch par.regtype
    
    case "o meu"
        
        C=1;
        
        gradmod = calc_gradmod(fn);
        div = calc_div(fn);
        
        reg_term = div;
        
        

    case "length" 
        deltasum=0;
        for a=1:size(l,1)
            deltasum=deltasum+delta(e,fn-l(a));
        end
        m1 = mu.*(deltasum);
        
        div(2:end-1,2:end-1) = ...
            C1(2:end-1,2:end-1).*fn(3:end,2:end-1)+ ...
            C2(2:end-1,2:end-1).*fn(1:end-2,2:end-1)+ ...
            C3(2:end-1,2:end-1).*fn(2:end-1,3:end)+ ...
            C4(2:end-1,2:end-1).*fn(2:end-1,1:end-2);
        
        C=1+m1.*(C1+C2+C3+C4);
        reg_term = m1.*div;
        
    case "tv"
        m1 = mu;
        
        div(2:end-1,2:end-1) = ...
            C1(2:end-1,2:end-1).*fn(3:end,2:end-1)+ ...
            C2(2:end-1,2:end-1).*fn(1:end-2,2:end-1)+ ...
            C3(2:end-1,2:end-1).*fn(2:end-1,3:end)+ ...
            C4(2:end-1,2:end-1).*fn(2:end-1,1:end-2);
        
        C=1+m1.*(C1+C2+C3+C4);
        reg_term = m1.*div;
    case "mean curvature"
        
        m1=mu;
        
        gradx = .5*finite_diff(fn, 'c', 'x');
        grady = .5*finite_diff(fn, 'c', 'y');
        gradmod = (gradx.^2 + grady.^2).^(1/2);
        
        div(2:end-1,2:end-1) = ...
            C1(2:end-1,2:end-1).*fn(3:end,2:end-1)+ ...
            C2(2:end-1,2:end-1).*fn(1:end-2,2:end-1)+ ...
            C3(2:end-1,2:end-1).*fn(2:end-1,3:end)+ ...
            C4(2:end-1,2:end-1).*fn(2:end-1,1:end-2);
        
        div = div.*gradmod;
        C=1+m1.*(C1+C2+C3+C4);
        reg_term = m1.*div;
        
    case "H1"
        
        m1=2*mu;
        
        div = del2(fn);
end


end

function Theta = abs_2layers(fn, dim) % old uDenominatorXY

if dim == 1
    df1p = finite_diff(fn, 'x', 'f');
    df2c = finite_diff(fn, 'y', 'c');
elseif dim == 2
    df1p = finite_diff(fn, 'y', 'f');
    df2c = finite_diff(fn, 'x', 'c');
end
    
Theta = df1p.^2 + df2c.^2/4;        % protection against division by 0
ix0 = (Theta==0);                   % crude: replace all 0's with
replacementVal = min(Theta(~ix0));  % the next minimum found in the
Theta(ix0) = replacementVal;        % denominator; smarter later
Theta = 1./sqrt(Theta);

end

function Theta = abs_multigeneral(fn, dim)

a = zeros(size(fn,1), size(fn,2));
b = zeros(size(fn,1), size(fn,2));

switch dim
    case {1,3}
        a(1:end-1,:)=fn(2:end,:)-fn(1:end-1,:);
        a(end,:)=fn(end,:)-fn(end-1,:);
        a(end,:)=a(end-1,:);
        b(:,1:end-1)=fn(:,2:end)-fn(:,1:end-1);
        b(:,end)=fn(:,end)-fn(:,end-1);
        b(:,end)=b(:,end-1);
    case 2
        a(2:end,:)=fn(2:end,:)-fn(1:end-1,:);
        a(1,:)=fn(2,:)-fn(1,:);
        a(1,:)=a(2,:);
        b(2:end,1:end-1)=fn(1:end-1,2:end)-fn(1:end-1,1:end-1);
        b(1,1:end-1)=fn(1,2:end)-fn(1,1:end-1);
        b(2:end,end)=fn(1:end-1,end)-fn(1:end-1,end-1);
        b(1,end)=b(1,end-1);
        b(1,1:end-1)=b(2,1:end-1);
        b(2:end,end)=b(2:end,end-1);
        b(1,end)=b(2,end-1); 
    case 4
        a(1:end-1,2:end)=fn(2:end,1:end-1)-fn(1:end-1,1:end-1);
        a(1:end-1,1)=fn(2:end,1)-fn(1:end-1,1);
        a(end,2:end)=fn(end,2:end)-fn(end-1,2:end);
        a(end,1)=a(end-1,1);
        a(1:end-1,1)=a(1:end-1,2);
        a(end,2:end)=a(end-1,2:end);
        a(end,1)=a(end-1,2);
        b(:,2:end)=fn(:,2:end)-fn(:,1:end-1);
        b(:,1)=fn(:,2)-fn(:,1);  
        b(:,1)=b(:,2);

end
    
Theta = a.^2 + b.^2;%/4;        % protection against division by 0
ix0 = (Theta==0);                   % crude: replace all 0's with
replacementVal = min(Theta(~ix0));  % the next minimum found in the
Theta(ix0) = replacementVal;        % denominator; smarter later
Theta = 1./sqrt(Theta);

end