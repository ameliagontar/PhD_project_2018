function I_r = GetRadialIndex

% 25 October 2015
%
% A function that computes the radial index for all images in the yeast
% colony data set. Row t and column s corresponds to the radial index for
% sample s at time t. 

load RCSRscaled.mat
load Rscaled.mat
I_r = zeros(8,10);
for t = 1:8
    for s = 1:10
        Rcsr = RCSRscaled(t,s);
        R = Rscaled(t,s);
        I = 1-Rcsr/R;
        I_r(t,s) = I;
    end
end