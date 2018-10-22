function [coeffs_of_determ,C,R_squared_max,best_fts] = BestMultipleRegression(Y,H,no_features)

% 6 February 2017
%
% A program that runs through all combinations of no_features features,
% computes the coefficient of determination R_squared for each combination,
% and then chooses the best one. Y is the N x 1 vector of actual output
% values, where N is the number of observations. In the case of steak
% marbling, Y will be the vector MarbProportions, the actual marbling
% proportions obtained from the steaks. H is the N x k array of histograms
% of texton occurrences, where N is the number of observations and k is the
% number of textons.
%
% coeffs_of_determ is the vector of all coefficients of determination, one
% for each combination of features. R_squared_max is the best coefficient
% of determination, and best_fts is the vector of indices of the features
% used to obtain the best coefficient of determination.

[~,k] = size(H);
v = 1:k;
C = nchoosek(v,no_features);
[no_comb,~] = size(C);
coeffs_of_determ = zeros(no_comb,1);
for m = 1:no_comb
    fvec = C(m,:);
    F = H(:,fvec);
    [~,R_squared] = MultipleRegressionFeatures(Y,F);
    coeffs_of_determ(m) = R_squared;
end

[R_squared_max,i] = max(coeffs_of_determ);
best_fts = C(i,:);

