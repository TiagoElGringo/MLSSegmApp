function fn = reinitialize(mask)
mask=mask>0;
fn = -bwdist(mask,'euclidean');
% also do the inside!!!
temp = bwdist(~mask,'euclidean');
fn(mask) = temp(mask);
clear temp
%fn=fn+60;

%fn=fn.*10;
%fn = double(2*(mask>0)-1);
end