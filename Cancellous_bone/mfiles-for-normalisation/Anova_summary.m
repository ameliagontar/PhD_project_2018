function [MSB,MSE,F,p] = Anova_summary(mn,s,trials)

% 6 November 2015
%
% A function that performs an ANOVA using only data summaries, i.e. the
% mean and standard deviation of each sample. mn is a (column) vector of sample
% means, s is the vector of corresponding standard deviations, and
% trials is the corresponding sample size. The input vectors must be column
% vectors. The program has been verified for cases where the number of
% trials is the same for all groups.

% Calculate the global sample mean:
x_global = sum(trials.*mn)/sum(trials);

% Calculate the total number of samples:
n = sum(trials);

% Calculate number of groups:
c = length(mn);

% Calculate the between-group variance:
% MSB = mean standard variance between groups
a = ones(c,1);
x_global_vec = x_global*a;
MSB = (sum(trials.*(mn-x_global_vec).^2)/(c-1));

% Calculate the within-group variance (i.e. pooled variance):
% MSE = mean standard error
var = s.^2;
one_vec = ones(c,1);
MSE = sum((trials-one_vec).*var)/(n-c);

% Calculate the F-statistic:
F = MSB/MSE;

% Compare F-statistic to the F distribution:
p = fcdf(F,c-1,n-c,'upper');