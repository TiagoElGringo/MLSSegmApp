path = 'D:\5 ano 2 S\Tese\Matlab\My_algorithms\app\Functions\results for table\';
first = load([path 'fogo1sequence1_34to682_a0to100e3_mu1to15e-3_sigma2.mat']);
%getResultsTable(first.data);
[n(1),IOU1, time1] = getResultsTable(first.data);

second = load([path 'fogo1sequence2_21to453_a0to100e3_mu1to15e-3_sigma2.mat']);
[n(2),IOU2, time2] = getResultsTable(second.data);

third = load([path 'fogo1sequence3_71to239_a0to100e3_mu1to15e-3_sigma2.mat']);
[n(3),IOU3, time3] = getResultsTable(third.data);

generalResultsTable = (IOU1.*n(1)+IOU2.*n(2)+IOU3.*n(3))/sum(n,'all');
generaltime = (sum(time1.*(time1<20),'all').*n(1)+sum(time2.*(time2<20),'all').*n(2)+sum(time3.*(time3<20),'all').*n(3))/(sum(n,'all')*numel(time1));

function [n_images,resultsTable,timeTable] = getResultsTable(data)

vars = ["mu";"alpha";"sigma"];

alpha_vec = unique(data.results.alpha);
mu_vec = unique(data.results.mu);
sigma_vec = unique(data.results.sigma);

n_images = size(unique(data.results.nome),2);
totalsize = size(alpha_vec,2)*size(mu_vec,2)*size(sigma_vec,2);

maskfind = zeros(totalsize);
resultsTable = zeros(size(mu_vec,2),size(alpha_vec,2),size(sigma_vec,2));

for s=1:size(sigma_vec,2)
    for i=1:size(alpha_vec,2)
       for j=1:size(mu_vec,2)
            sigmaGoal = data.results.sigma == sigma_vec(s);
            alphaGoal = data.results.alpha == alpha_vec(i);
            muGoal = data.results.mu == mu_vec(j);
            maskfind = sigmaGoal.*alphaGoal.*muGoal;
            interestValues = data.results.IOU(maskfind == 1);
            interestTime = data.results.time(maskfind == 1);
            resultsTable(j,i,s) = sum(interestValues,'all')/numel(interestValues);
            timeTable(j,i,s) = sum(interestTime,'all')/numel(interestTime);
       end
    end 
end


end