function df = finite_diff(f, xory, method) %finite differences

df = zeros(size(f,1), size(f,2));

switch method
    
    case 'f' %forward
        if xory == 'x'
            df(:,1:end-1) = f(:,2:end) - f(:,1:end-1);
            df(:,end) = f(:,end) - f(:,end-1);
        elseif xory == 'y'
            df(1:end-1,:) = f(2:end,:) - f(1:end-1,:);
            df(end,:) = f(end,:) - f(end-1,:);
        else
            error('type not allowed');
        end
        
    case 'b' %backward
        if xory == 'x'
            df(:,2:end) = f(:,2:end) - f(:,1:end-1);
            df(:,1) = f(:,2) - f(:,1);
        elseif xory == 'y'
            df(2:end,:) = f(2:end,:) - f(1:end-1,:);
            df(1,:) = f(2,:) - f(1,:);
        else
            error('type not allowed');
        end
        
    case 'c' %central
        switch xory
            case 'x'
                df(:,1) = f(:,2) - f(:,1);
                df(:,2:end-1) = f(:,3:end) - f(:,1:end-2);
                df(:,end) = f(:,end) - f(:, end-1);
                df(:,1) = df(:,2);
                df(:,end) = df(:,end-1);
            case 'y'
                df(1,:) = f(2,:) - f(1,:);
                df(2:end-1,:) = f(3:end,:) - f(1:end-2,:);
                df(end,:) = f(end,:) - f(end-1,:);
                df(1,:) = df(2,:);
                df(end,:) = df(end-1,:);
            case 'xx'
                df(:,2:end-1) = f(:,3:end) + f(:,1:end-2) - 2.*f(:,2:end-1);
                df(:,1) = df(:,2);
                df(:,end) = df(:,end-1);
            case 'yy'
                df(2:end-1,:) = f(3:end,:) + f(1:end-2,:) - 2.*f(2:end-1,:);
                df(1,:) = df(2,:);
                df(end,:) = df(end-1,:);
            case 'xy'
                df(2:end-1,2:end-1) = f(3:end,3:end) - f(1:end-2,3:end) - f(3:end,1:end-2) - f(1:end-2,1:end-2);
                df(:,1) = df(:,2);
                df(:,end) = df(:,end-1);
                df(1,:) = df(2,:);
                df(end,:) = df(end-1,:);
       
        end
    otherwise 
        disp("ta male");
        return;
end
end