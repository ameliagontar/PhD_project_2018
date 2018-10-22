function F_Theta = IndexOfAggregation(im,ns,N)

% 18 August 2016
%
% Calculates the (angular) pair-correlation index of aggregation as per
% Binder et al. 2015. im is the yeast growth (image), ns is the number of
% subsampled points, and N is the number of bins.

angle_cnt = CountPairs(im,ns,N);
F_Theta = (2*N*angle_cnt)/(ns*(ns-1));
%S = sum(sum(im));
%I_Theta = F_Theta-ns/S;