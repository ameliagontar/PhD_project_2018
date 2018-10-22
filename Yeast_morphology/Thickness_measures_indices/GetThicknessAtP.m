function thicknesses = GetThicknessAtP(r,c,no_dir,stepsize,im,phi,resrat)

% 8 August 2016
%
% For one pixel p, computes the length of the line segment lying entirely 
% within the yeast growth, in no_dir directons. There are therefore 
% pi/no_dir radians between measurements. This program will likely be 
% updated to take into account rotation invariance, with thickness 
% measurements in 12 directions being a preliminary method of computing 
% "pattern primitives." All measurements are conducted in terms of radians,
% with angles being measured anticlockwise from the x axis. 
%
% r is the row index and c is the column index of p. stepsize is the size
% of the step used to subsample points in order to measure thickness. im is
% the image. EDIT 11 August 2016: phi is the angle that the line joining 
% the centre to the pixel of interest makes with the x axis. All angles are
% measured with respect to this angle. For the experiment without rotation
% invariance, phi = 0 for each pixel.
%
% The program is written with the intention that p has already been chosen
% as a 'reasonable' pixel at which to take the thickness measurement, e.g.
% it is a boundary pixel. If p is an off pixel, then the program returns a
% row of zeros.
%
% EDIT 31 March 2017: the variable resrat (resolution ratio) has been
% added. This is the ratio used to convert the number of pixels to an
% absolute length in micrometres. resrat has been calculated separately
% from the scale bars provided by Ben. 

[R,C] = size(im);
thicknesses = zeros(1,no_dir);
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
    thicknesses(n) = thck_pos+thck_neg;
end

thicknesses = resrat*thicknesses;
        