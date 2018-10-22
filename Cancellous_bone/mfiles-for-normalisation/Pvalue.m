function [t,df,p] = Pvalue(ma,mb,sa,sb,na,nb)

% 3 November 2015
%
% A function that performs a two-sample t-test, which tests if two means
% are statistically significantly different. ma and mb are the means of
% groups a and b respectively; sa and sb are the std's of groups a and
% b respectively; and na and nb are the sample sizes of groups a and b
% respectively.

% Null hypothesis: the population means are equal, i.e. mu_a - mu_b = 0.
% Alternative hypothesis: mu_a - mu_b =/= 0 (two-tailed t-test, i.e. this
% function is not testing whether one mean is strictly larger than the
% other).

% Compute the test statistic t:
t = (ma-mb)/sqrt((sa^2/na)+(sb^2/nb));
t = abs(t);

% Compute the degrees of freedom df:
numerator = ((sa^2/na)+(sb^2/nb))^2;
denominator = (1/(na-1))*(sa^2/na)^2 + (1/(nb-1))*(sb^2/nb)^2;
df = numerator/denominator;

% Find the p-value:
p = 2*(1-tcdf(t,df));