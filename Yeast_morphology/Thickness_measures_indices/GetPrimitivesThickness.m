function prims = GetPrimitivesThickness(no_dir,stepsize,im,RIflag,resrat)

% 8 August 2016
%
% Computes "pattern primitives" for a single binary image im. Selects
% boundary pixels and computes the longest line segment lying in Omega in 
% no_dir directions. This results in an angle of pi/no_dir radians per
% measurement. Since there are only about 12000-20000 boundary pixels for 
% the majority of images, do not subsample and instead compute pattern
% primitives at ALL boundary pixels. stepsize is the step size used to make
% the thickness measurement. 
%
% EDIT 11 August 2016: This program has been edited to incorporate rotation
% invariance. For each pixel p, the angle that its coordinates make with
% the x axis is calculated, and the thicknesses are measured with respect
% to this new angle, rather than 0. RI flag is the rotation invariance
% flag. RIflag = 1 if the rotation invariance experiment is being
% conducted, RIflag = 0 if rotation invariance is off.
%
% EDIT 31 March 2017: resrat is the resolution ratio, i.e. the ratio used
% to convert the number of pixels to an absolute length in micrometres.
% This ratio will be slightly different for each data set. 

% Find centre of yeast growth in the image im:
[y_coords,x_coords] = find(im);
x_mean = mean(x_coords);
y_mean = mean(y_coords);

% For each pixel p, find its coordinates and angle, and compute the no_dir
% thicknesses:
[~,~,idx] = FindPixels(im);
[L,~] = size(idx);
prims = zeros(L,no_dir);
for l = 1:L
    r = idx(l,1);
    c = idx(l,2);
    if RIflag == 1
        phi = GetAngle(x_mean,y_mean,c,r);
    else
        phi = 0;
    end
    thicknesses = GetThicknessAtP(r,c,no_dir,stepsize,im,phi,resrat);
    prims(l,:) = thicknesses;
end