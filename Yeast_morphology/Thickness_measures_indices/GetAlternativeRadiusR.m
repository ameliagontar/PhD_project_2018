function R = GetAlternativeRadiusR(im)

% 25 October 2016
%
% Computes the largest radial distance R, according to Binder 2015. More
% closely resembles the definition of R in Ben's paper. For one image im.

[~,~,idx] = FindPixels(im);
xcoords = idx(:,1);
xmin = min(xcoords);
xmax = max(xcoords);
R = (xmax-xmin)/2;