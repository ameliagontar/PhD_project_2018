function [L1,L2,xcoord_finish1,ycoord_finish1,xcoord_finish2,ycoord_finish2,xcoord_finish3,ycoord_finish3,xcoord_finish4,ycoord_finish4] = GetThicknessForEllipses(im,ell,stepsize)

% 7 September 2016
%
% Given an ellipse that has been fit to the colony, measures the thickness
% of the colony in the major and minor directions defined by the ellipse,
% starting from the centre of the ellipse. ell is a row vector that defines
% the ellipse, where the first two columns are the x and y coordinates of
% the centre, columns 3--4 are the unit eigenvector in the major direction,
% columns 5--6 are the components of the unit eigenvector in the minor
% direction. Columns 7--8 are the lengths of the major and minor semi-axes,
% respectively, but these will not be used here. stepsize is the step size
% used to make the thickness measurements, usually 1/sqrt(2). im is the
% image (colony).
%
% If the centre of the ellipse falls outside the colony, then L1=L2=0. 

Cx = ell(1);
Cy = ell(2);
u11 = ell(3);
u12 = ell(4);
u21 = ell(5);
u22 = ell(6);
[A,B] = size(im);

% Measure thickness in major direction:
xcoord = Cx;
ycoord = Cy;
xpixel = floor(xcoord)+1;
ypixel = floor(ycoord)+1;
count_pos = 0;
while xpixel > 0 && xpixel <= B && ypixel > 0 && ypixel <= A && ...
        im(ypixel,xpixel) == 1 
    xcoord = xcoord+stepsize*u11;
    ycoord = ycoord+stepsize*u12;
    count_pos = count_pos+1;
    xpixel = floor(xcoord)+1;
    ypixel = floor(ycoord)+1;
end
thickness_pos = stepsize*count_pos;
xcoord_finish1 = xcoord;
ycoord_finish1 = ycoord;
xcoord = Cx;
ycoord = Cy;
xpixel = floor(xcoord)+1;
ypixel = floor(ycoord)+1;
count_neg = 0;
while xpixel > 0 && xpixel <= B && ypixel > 0 && ypixel <= A && ...
        im(ypixel,xpixel) == 1 
    xcoord = xcoord-stepsize*u11;
    ycoord = ycoord-stepsize*u12;
    count_neg = count_neg+1;
    xpixel = floor(xcoord)+1;
    ypixel = floor(ycoord)+1;
end
xcoord_finish2 = xcoord;
ycoord_finish2 = ycoord;
thickness_neg = stepsize*count_neg;
L1 = thickness_pos+thickness_neg;

% Measure thickness in minor direction:
xcoord = Cx;
ycoord = Cy;
xpixel = floor(xcoord)+1;
ypixel = floor(ycoord)+1;
count_pos = 0;
while xpixel > 0 && xpixel <= B && ypixel > 0 && ypixel <= A && ...
        im(ypixel,xpixel) == 1 
    xcoord = xcoord+stepsize*u21;
    ycoord = ycoord+stepsize*u22;
    count_pos = count_pos+1;
    xpixel = floor(xcoord)+1;
    ypixel = floor(ycoord)+1;
end
thickness_pos = stepsize*count_pos;
xcoord_finish3 = xcoord;
ycoord_finish3 = ycoord;
xcoord = Cx;
ycoord = Cy;
xpixel = floor(xcoord)+1;
ypixel = floor(ycoord)+1;
count_neg = 0;
while xpixel > 0 && xpixel <= B && ypixel > 0 && ypixel <= A && ...
        im(ypixel,xpixel) == 1 
    xcoord = xcoord-stepsize*u21;
    ycoord = ycoord-stepsize*u22;
    count_neg = count_neg+1;
    xpixel = floor(xcoord)+1;
    ypixel = floor(ycoord)+1;
end
xcoord_finish4 = xcoord;
ycoord_finish4 = ycoord;
thickness_neg = stepsize*count_neg;
L2 = thickness_pos+thickness_neg;
        
