function [meanx,meany,r,filaments] = FindRadius(im)

% 5 September 2016
%
% For one sample im, computes the distance between the centre of the colony
% and each of the boundary pixels, and then finds the minimum of this
% distance. This is intended to find the "radius" r of the yeast colony,
% i.e. the largest radius into which we can fit a perfect circle. We may
% think of this circle as the circle out of which the filaments grow.
%
% Subtracts the circle from the yeast colony, leaving only the
% "filamentous" part, called filaments. This gives more meaningful points
% at which to compute ellipses. We may compute an ellipse for every point
% in filaments, or choose another method for subsampling. filaments is the
% same size as the original image im. 

[r,c] = find(im);
meanx = mean(c);
meany = mean(r);
[pixel_cnt,~,idx] = FindPixels(im);
distances = zeros(pixel_cnt,1);
for k = 1:pixel_cnt
    xcoord = idx(k,2)-0.5;
    ycoord = idx(k,1)-0.5;
    D = sqrt((xcoord-meanx).^2+(ycoord-meany).^2);
    distances(k) = D;
end
r = min(distances);
%r_max = max(distances);
[a,b] = size(im);
xv = 1:b;
yv = 1:a;
[X,Y] = meshgrid(xv,yv);
circle = ((X-meanx).^2+(Y-meany).^2 <= r^2);
circle = double(circle);
filaments = im-circle;
