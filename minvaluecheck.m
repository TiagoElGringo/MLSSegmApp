function f = minvaluecheck(f, minacceptvalue)

newvaluemin = -10;
newvaluemax=100;
maxacceptvalue=100;

f(f<minacceptvalue)=newvaluemin;
f(f>maxacceptvalue)=newvaluemax;

%{
while 1
    [minvalue,pos] = min(f,[],'all','linear');
    
    if minvalue<minacceptvalue
        f(pos)=newvalue;
    else
        break;
    end    
end

newvalue=100;
maxacceptvalue=100;
while 1
    [maxvalue,pos] = max(f,[],'all','linear');
    if maxvalue>maxacceptvalue
        f(pos)=newvalue;
    else
        break;
    end
end
%}

end