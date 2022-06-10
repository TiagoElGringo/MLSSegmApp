function [contoursLength, contoursNumber] = getContoursLength(data)

contoursLength = zeros(data.par.nlevels,1);
contoursNumber = zeros(data.par.nlevels,1);

for i = [1,2]
    contours = contour(data.phi-data.par.l(i), [0 0]);
    [clen, ~] = contourlengths(contours);
    contoursLength(i) = sum(clen,'all');
    contoursNumber(i) = numel(clen);
end

contoursLength = nonzeros(contoursLength);
contoursNumber = nonzeros(contoursNumber);

end