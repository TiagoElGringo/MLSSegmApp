function data = build_mask(data)

f=data.phi;
l=data.par.l;

mask = zeros(size(f));
%mask(f>=10&f<l(end-1))=1;
%mask(f>=l(end-1)&f<l(end))=2;
%mask(f>l(end))=3;

for i=1:size(l)
    mask(f>=l(i))=i;
end

mask(mask<=1)=0;
mask(mask>=2&mask<=4)=1;
mask(mask==5)=2;

data.mask = uint8(mask);

end