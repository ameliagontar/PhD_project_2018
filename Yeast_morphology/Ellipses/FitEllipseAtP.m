function [cc,C,V1,V2,lgths] = FitEllipseAtP(im,r,xcoord,ycoord)

% 6 September 2016
%
% Given a point inside the binary image, draws a circle of radius r, finds
% the largest connected component inside that circle, and fits an ellipse
% to that connected component. im is the binary image, not necessarily one
% connected component only, r is the radius of the ball we are fitting, and
% (xcoord, ycoord) are the coordinates of the point we are starting at.
%
% C is the centroid of the ellipse, V1 is the normalised direction vector 
% in the major direction, V2 is the normalise direction vector in the minor
% direction, and lgths are the lengths of the semi-major and semi-minor
% axes, respectively.

% Pad the image, so that the ball is guaranteed to fit:
[a,b] = size(im);
r_rounded = ceil(r);
im_padded = zeros(a+2*r_rounded,b+2*r_rounded);
im_padded(r_rounded+1:r_rounded+a,r_rounded+1:b+r_rounded) = im;
xnew = xcoord+r_rounded;
ynew = ycoord+r_rounded;

% Create a new array to 'house' the ball:
[A,B] = size(im_padded);
xv = 1:B;
yv = 1:A; 
[X,Y] = meshgrid(xv,yv);
Rsq = (X-xnew).^2+(Y-ynew).^2;
circle = Rsq<=r^2;
circle = double(circle);

% Find the part of the image that intersects with the circle. Call it omega:
checkarray = im_padded+circle;
omega = checkarray==2;
omega = double(omega);

% Find the largest connected component of omega:
CC = bwconncomp(omega);
components = CC.PixelIdxList;
L = length(components);
size_array = zeros(L,1);
for l = 1:L
    idxlist = components{l};
    comp_size = length(idxlist);
    size_array(l) = comp_size;
end
[~,i] = max(size_array);
I = components{i};
binarystretched = zeros(A*B,1);
binarystretched(I) = 1;
cc = reshape(binarystretched,A,B);
cc = cc(r_rounded+1:r_rounded+a,r_rounded+1:r_rounded+b);

% Fit an ellipse to this largest connected component:
[C,V1,V2,lgths] = FitEllipseConnComp(cc);