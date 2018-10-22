function [draw_ell,im_pad] = DrawOneEllipse(im,E)

% 5 January 2017
%
% A function that draws an ellipse E using meshgrid. Assumes that E is a
% vector of length eight, with the first two elements being the centroid of
% the ellipse. Elements 3--4 correspond to the unit eigenvector giving the
% direction of the major axis, elements 5--6 correspond to the direction of
% the minor axis, and elements 7--8 are the lengths of the semi-major and
% semi-minor axes, respectively. im is the original image that the ellipse 
% has been fit to, so we can later overlay the ellipsoid over the image and
% keep coordinates consistent. draw_ell is a binary image of the ellipse,
% drawn using meshgrid.
%
% The original image and the image of the ellipse are padded, to account
% for the possibility of the ellipsoid being wider than the image itself.
% This is unlikely to occur in the context of the yeast colony data, since
% most of the colonies lie in the centre of each image. However, this
% program is written for generality and to avoid possible errors. im_pad is
% the padded image, for use later.

% Make a meshgrid of the same size as the original image, plus padding:
[a,b] = size(im);
ap = ceil(0.25*a);
bp = ceil(0.25*b);
vx = 1:b+2*bp;
vy = 1:a+2*ap;
[X,Y] = meshgrid(vx,vy);

% Extract important information about the ellipse:
xo = E(1)+bp;
yo = E(2)+ap;
V = [E(3),E(5);E(4),E(6)];
l1 = E(7);
l2 = E(8);

% Pad the original image:
im_pad = zeros(a+2*ap,b+2*bp);
im_pad(ap+1:ap+a,bp+1:bp+b) = im;

% Transform the coordinates:
Vt = V'./det(V');
x_new = Vt(1,1)*(X-xo)+Vt(1,2)*(Y-yo);
y_new = Vt(2,1)*(X-xo)+Vt(2,2)*(Y-yo);

% Define the ellipse:
draw_ell = ((x_new./l1).^2+(y_new./l2).^2 <= 1);
draw_ell = double(draw_ell);

