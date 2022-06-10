function [mask_0] = drawmaskasf(type, size, phi_id)

mask_0=zeros(size);
mask_xc = round(size(1)/2);
mask_yc = round(size(2)/2);

if type == "circle"
    
    R = round(.4*min(size));
    
    mask = DrawCircle(R);
    
    mask_0(mask_xc-R:mask_xc+R, mask_yc-R:mask_yc+R) = mask;

elseif type == "rectangle"
   
    R=round(.8*size(1)/2);
    C=round(.8*size(2)/2);
    mask = ones(R*2+1, C*2+1);    
    mask_0(mask_xc-R:mask_xc+R, mask_yc-C:mask_yc+C) = mask;
    
elseif type == "multicircles"
    
    R_singlemask = 15;
    R_circle = round(.3*R_singlemask);
    
    n_circles_column = floor(size(1)/(R_singlemask));
    n_circles_line = floor(size(2)/(R_singlemask)); 
    
    circle = DrawCircle(R_circle);
    
    center = round(R_singlemask/2); %center of singlemask
    
    singlemask = zeros(R_singlemask);
    %single_mask
    singlemask(center-R_circle:center+R_circle, center-R_circle:center+R_circle) = circle;

    R=n_circles_column*R_singlemask;
    C=n_circles_line*R_singlemask;
    mask=zeros(R,C);
    for i=1:n_circles_line
        for j=1:n_circles_column
            mask((1+(j-1)*R_singlemask):(j*R_singlemask),(1+(i-1)*R_singlemask):(i*R_singlemask))= singlemask;
        end
    end
    
    if rem(size(1),2)~=0, mask_xc=(size(1)-1)/2; end
    if rem(size(2),2)~=0, mask_yc=(size(2)-1)/2; end
    mask_0(mask_xc-R/2+1:mask_xc+R/2, mask_yc-C/2+1:mask_yc+C/2) = mask;
    
    
end


%figure(45);imagesc(mask); colormap(gray);
%figure(46);imagesc(mask_0); colormap(gray);
    
end

function mask = DrawCircle(R)

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
    
    %R=R-1;
end