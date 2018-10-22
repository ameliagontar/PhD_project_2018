function [mean_prop,std_prop,lower_ci,upper_ci] = Trials
%[prop,feature,mean_prop,std_prop,lower_ci,upper_ci] = Trials

% 21 October 2015
%
% A function that allows us to conduct multiple trials of an experiment and
% record the number of correct assignments, best feature, etc.

tic
N = 30;     % number of trials

prop = zeros(N,1);
%feature = zeros(N,1);

for n = 1:N
    [bestacc,bestF,bestconfus,accvec] = Exp1F3;
    prop(n) = bestacc;
    %feature(n,:) = bestF;
end

mean_prop = mean(prop);
std_prop = std(prop);
lower_ci = mean_prop-2*std_prop;
upper_ci = mean_prop+2*std_prop;

toc