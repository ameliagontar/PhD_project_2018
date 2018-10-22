function [prop,mean_prop,std_prop] = Trials
%[feature,prop,mean_prop,std_prop] = Trials

% 21 October 2015
%
% A function that allows us to conduct multiple trials of an experiment and
% record the number of correct assignments, best feature, etc.

N = 30;     % number of trials

prop = zeros(N,1);
%feature = zeros(N,3);

for n = 1:N
    [bestacc,bestF,bestconfus,accvec] = Exp1F3_rand;
    %prop(n) = acc;
    %[bestacc,bestF,bestconfus,accvec] = Exp1F3_rand_gamma;
    prop(n) = bestacc;
    %feature(n,:) = bestF;
end

mean_prop = mean(prop);
std_prop = std(prop);
