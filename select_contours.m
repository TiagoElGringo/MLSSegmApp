function [cont,indexes] = select_contours(c)

targets = [65];

for i=1:size(targets)
    [~,idx] = min(abs(c-targets(i)));
    cont(i,1)=c(idx);
    indexes(i,1)=idx;
    c(idx)=-100;
end


end