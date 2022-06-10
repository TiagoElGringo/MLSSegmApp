function g0 = pre_process(I)

if (size(I,3)==3)
    BW = rgb2gray(I);
else
    BW = I;
end

%minInt = min(BW,[],'all');
color = 'black';
%color = [minInt minInt minInt];

if (isequal(size(BW),[576,768]))
    NT = insertShape(BW,'FilledRectangle', [0 0 768 28], 'color', color, 'opacity', 1);
    NT = insertShape(NT,'FilledRectangle', [550 60 135 22], 'color', color, 'opacity', 1);
    NT = insertShape(NT,'FilledRectangle', [550 82 210 40], 'color', color, 'opacity', 1);
    NT = insertShape(NT,'FilledRectangle', [550 122 180 20], 'color', color, 'opacity', 1);
    NT = insertShape(NT,'FilledRectangle', [570 495 180 80], 'color', color, 'opacity', 1);
    NT = insertShape(NT,'FilledRectangle', [570 495 180 80], 'color', color, 'opacity', 1);
    NT = insertShape(NT,'FilledRectangle', [0 110 65 360], 'color', color, 'opacity', 1);
    NT = insertShape(NT,'FilledRectangle', [213 28 345 16], 'color', color, 'opacity', 1);
elseif (isequal(size(BW),[480,640]))
    NT = insertShape(BW,'FilledRectangle', [0 0 180 100], 'color', color, 'opacity', 1);
    NT = insertShape(NT,'FilledRectangle', [0 0 640 25], 'color', color, 'opacity', 1);
    NT = insertShape(NT,'FilledRectangle', [0 455 640 25], 'color', color, 'opacity', 1);
    NT = insertShape(NT,'FilledRectangle', [445 400 200 70], 'color', color, 'opacity', 1);
    NT = insertShape(NT,'FilledRectangle', [430 80 135 80], 'color', color, 'opacity', 1);
    NT = insertShape(NT,'FilledRectangle', [430 60 122 20], 'color', color, 'opacity', 1);
    NT = insertShape(NT,'FilledRectangle', [430 80 210 40], 'color', color, 'opacity', 1);
    NT = insertShape(NT,'FilledRectangle', [0 0 64 420], 'color', color, 'opacity', 1);
elseif(isequal(size(BW),[1088,1920]))
    NT = BW(10:369, 10:489);
    NT = insertShape(NT,'FilledRectangle', [0 0 480 35], 'color', color, 'opacity', 1);
    NT = insertShape(NT,'FilledRectangle', [0 0 50 360], 'color', color, 'opacity', 1);
    NT = insertShape(NT,'FilledRectangle', [0 340 480 20], 'color', color, 'opacity', 1);
    NT = insertShape(NT,'FilledRectangle', [320 0 160 120], 'color', color, 'opacity', 1);
    NT = insertShape(NT,'FilledRectangle', [330 300 150 60], 'color', color, 'opacity', 1);
end

NT = rgb2gray(NT);

g0 = double(NT);
%g0=NT;

end