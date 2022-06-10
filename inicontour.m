function data = inicontour(data)
   
[nR, nC] = size(data.g);

sphi = false(nR,nC);
N = 1;
Rad = floor(nC/(4*N));
% find  y_centers (along nC)
y_c = (2*Rad:4*Rad:nC);
% and x_centers (along nR), with their offset
Nr = floor(nR/4/Rad+1/2);
x_offset = floor((nR-2*Rad*(2*Nr-1))/2);
x_c = (x_offset+Rad:4*Rad:nR-Rad);

% figure out mask of each circle (boolean->sign)
mask = drawCircle(Rad, 1);
% replicate this disk -> assign 'true' into binary matrix
for i = 1:size(x_c,2)
    for j = 1:size(y_c,2)
        sphi(x_c(i)-Rad:x_c(i)+Rad, y_c(j)-Rad:y_c(j)+Rad) = mask;
    end
end

data.sphi = sphi;

% calc. Fn only if and where needed (inside thisGateMask)
data.fn = reinitialize(sphi>0);

% --- (re-)initialize Residue, Dirac
[Err_ini, ResidueSQ, Dirac, Hvi, gHvi] = opReset_Wrap(data);

% --- wipe older errors
data.err = Err_ini;
data.evol.Hvi = Hvi;
data.evol.gradHviMag = gHvi;
data.evol.Residue = ResidueSQ;
data.evol.Dirac = Dirac;
data.count.It = 0;
data.count.Steps = 0;
end