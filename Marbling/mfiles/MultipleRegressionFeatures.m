function [B,R_squared] = MultipleRegressionFeatures(Y,F)

% 27 January 2017
%
% A general program for multiple regression for any number of input
% features. Later, we can experiment with different numbers and
% combinations of features. F is an array of size N x p, where N is the
% number of observations and p is the number of features used for
% regression. Y is a vector of size N x 1, containing the observed output
% values.
%
% B is the (p+1) x 1 vector of regression coefficients, with the first
% element being the constant coefficient. R_squared is the coefficient of
% determination, or the multiple correlation coefficient. It gives the
% proportion of variability in Y described by regression on the X. 
%
% Note that using the function inv is not computationally efficient, and it
% will fail if the matrix X'*X is singular. However, this is the most
% mathematically true way of computing the betas. If the matrix X'*X is 
% singular, then we can skip the corresponding combination of features and
% move on to the next one. 
%
% Applied Linear Regression by Sanford Weisberg is a good reference for
% this content. The program has been validated using two examples from this
% book, and one example from Multiple Regression: A Primer by Paul D.
% Allison.

[N,~] = size(F);
coeff = ones(N,1);
X = [coeff,F];
B = inv(X'*X)*X'*Y;
%Y_hat = X*B;

Y_tilde = Y-mean(Y);
SYY = Y_tilde'*Y_tilde;
RSS = Y'*Y-B'*(X'*X)*B;
R_squared = (SYY-RSS)/SYY;