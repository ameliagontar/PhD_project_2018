function [centroid,V1,V2,V3,lgths] = Ellipsoid_fitball(vol,xcoord,ycoord,zcoord,radius)

% 10 May 2016
%
% Draws a ball around a coordinate, finds the largest connected component
% inside the ball, and fits an ellipsoid to this connected component.
%
% vol is a binary volume, with possibly more than one connected
% component. xcoord, ycoord, zcoord are the x-, y- and z-coordinates of the
% point we want to start at, relative to the original volume. radius is 
% the radius of the ball we want to draw. 

% Pad the volume, so that the ball is guaranteed to fit:
[A,B,C] = size(vol);
volume_padded = zeros(A+2*radius,B+2*radius,C+2*radius);
volume_padded(radius+1:radius+A,radius+1:radius+B,radius+1:radius+C) = vol;

% Construct the meshgrid for the ball, of same size as padded block:
v1 = 1:B+2*radius;
v2 = 1:A+2*radius;
v3 = 1:C+2*radius;
[x1,y1,z1] = meshgrid(v1,v2,v3);

% Construct the ball:
xshift = xcoord+radius;
yshift = ycoord+radius;
zshift = zcoord+radius;
Rsq = (x1-xshift).^2 + (y1-yshift).^2 + (z1-zshift).^2;
ball = Rsq<=radius^2;
ball = double(ball);

% Find where the volume and ball overlap:
array_sum = volume_padded+ball;
overlap = array_sum==2;
overlap = double(overlap);

% Find the largest connected component inside the ball:
CC = bwconncomp(overlap);
components = CC.PixelIdxList;
L = length(components);
sizes = zeros(L,1);
for l = 1:L
    pixels = components{l};
    sizes(l) = length(pixels);
end
[~,idx] = max(sizes);
biggestCC = components{idx};
[a,b,c] = size(overlap);
binarystretched = zeros(a*b*c,1);
binarystretched(biggestCC) = 1;
largestCC = reshape(binarystretched,a,b,c);
largestCC = largestCC(radius+1:radius+A,radius+1:radius+B,radius+1:radius+C);

% Fit an ellipsoid to this connected component:
[centroid,V1,V2,V3,lgths] = Ellipsoid_conncomp(largestCC);