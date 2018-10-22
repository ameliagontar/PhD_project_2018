function [thicknesses,thicknesses_draw] = GetThicknessAtP_fordemo(r,c,no_dir,stepsize,im,phi,resrat)

% 29 November 2017
%
% Edited from GetThicknessAtP.m. This program is simply designed to create
% images for the thesis, in particular to demonstrate rotation invariance.

[R,C] = size(im);
thicknesses_draw = [];
for n = 1:no_dir
    theta = phi+(n-1)*(pi/no_dir);
    xstep = cos(theta);
    ystep = sin(theta);
    xcoord = c-0.5;
    ycoord = r-0.5;
    xpixel = floor(xcoord)+1;
    ypixel = floor(ycoord)+1;
    cnt_p = 0;
    while xpixel > 0 && xpixel <= C && ypixel > 0 && ypixel <= R && ...
            im(ypixel,xpixel) == 1
        cnt_p = cnt_p+1;
        xcoord = xcoord+stepsize*xstep;
        ycoord = ycoord+stepsize*ystep;
        xpixel = floor(xcoord)+1;
        ypixel = floor(ycoord)+1;
    end
    thck_pos = stepsize*cnt_p;
    xcoord = c-0.5;
    ycoord = r-0.5;
    xpixel = floor(xcoord)+1;
    ypixel = floor(ycoord)+1;
    cnt_p = 0;
    while xpixel > 0 && xpixel <= C && ypixel > 0 && ypixel <= R && ...
            im(ypixel,xpixel) == 1
        cnt_p = cnt_p+1;
        xcoord = xcoord-stepsize*xstep;
        ycoord = ycoord-stepsize*ystep;
        xpixel = floor(xcoord)+1;
        ypixel = floor(ycoord)+1;
    end
    thck_neg = stepsize*cnt_p;
    thicknesses_draw = [thicknesses_draw,thck_neg,thck_pos];
    thicknesses(n) = thck_pos+thck_neg;
end

thicknesses = resrat*thicknesses;
        