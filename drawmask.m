function mask_0 = drawmask(type, size)

mask_0 = zeros(size);
mask_xc = round(size(1)/2);
mask_yc = round(size(2)/2);

if type == "circle"
    
    R = round((.1+(.4-.1)*rand())*min(size));
    
    R=R+1; %force odd
    
    %draw a quarter of the circle
    dc = .5 + (0:R-1); %distances of centers of pixels
    xc = repmat(dc, R, 1);
    yc = repmat(dc', 1, R);
    dc = sqrt(xc.^2 + yc.^2);
    mask = dc<=R;
    
    %create whole circle(by flipping 1/4 circle)
    mask = [flipud(mask); mask];
    mask = [fliplr(mask) mask];
    
    %get (R+1)th column in the middle
    mask = mask(([(1:R),(R+2:end)]),:);   %delete (R+1)-th row
    mask = mask(:,([(1:R),(R+2:end)]));   %delete (R+1)-th column
    
    R=R-1;
    mask_0(mask_xc-R:mask_xc+R, mask_yc-R:mask_yc+R) = mask;

elseif type == "rectangle"
    R=round(.8*size(1)/2);
    C=round(.8*size(2)/2);
    mask = ones(R*2+1, C*2+1);    
    mask_0(mask_xc-R:mask_xc+R, mask_yc-C:mask_yc+C) = mask;
end


%figure(45);imagesc(mask); colormap(gray);
%figure(46);imagesc(mask_0); colormap(gray);
    
end