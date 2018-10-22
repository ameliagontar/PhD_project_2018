function [cpvec,bestF_vec,cp_mean,cp_std] = Exp1F3Trials(NC,K)

% 23 April 2015 (Edited 8 April 2016)
%
% The aim is to run the program Exp1F3.m N times, and produce a vector
% of the proportion of correct assignments for rat blocks (9x9),
% of length N; then find the mean and std of prop. of correct assignments.
% NC is the number of textons per class and K is the number of trials.
% cp_mean and cp_std are the mean and standard deviation of the correct
% proportions, respectively.

cpvec = zeros(K,1);   % make a blank vector ("correct proportion" vector)
bestF_vec = zeros(K,3);

for k = 1:K
    [bestacc,bestF,~,~] = Exp1F3(NC);
    cpvec(k) = bestacc;
    bestF_vec(k,:) = bestF;
end

cp_mean = mean(cpvec);
cp_std = std(cpvec);

    