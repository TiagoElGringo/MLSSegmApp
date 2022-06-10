function data = change_resolution_phi(data, refine)

k = data.res.k;

% detect when k hits the boundaries, (0, kMax), spare the updates
DoOperation = (refine && (k>0)) || (~refine && (k < data.kMax));
if ~DoOperation
    disp('Not possible');
    return
end

% increment/decrement K (increase/decrease resolution level)
delta_k = ~refine*2 - 1;
k_next = k + delta_k;

% --- actual resolution change ---
% Full, 0-protect in Down (ignored), only used in Up
offset = data.gOffset(max(k,1),:);

switch data.par.nphi
    case 1
         phi_pr = resolution_op(data.phi, refine, offset);
        %data.phi_prev = resolution_op(data.phi_prev, refine, offset);
        data.gcurr = data.g{k_next+1}; % chk only...

        % preserve gradient values...
        %data.phi = phi_pr * 2^(-delta_k); % 2 when Up, 1/2 when Down
        data.phi = phi_pr;
        data.phi_prev = phi_pr;
        
    case 2
        for i=1:2
            phi_pr = resolution_op(data.phi{i}, refine, offset);
            %data.phi_prev = resolution_op(data.phi_prev, refine, offset);
            data.gcurr = data.g{k_next+1}; % chk only...

            % preserve gradient values...
            data.phi{i} = phi_pr * 2^(-delta_k); % 2 when Up, 1/2 when Down
            %data.phi{i} = phi_pr;
        end

end
data = calc_c(data);
data.res.k = k_next;

end
