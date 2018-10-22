function ellipses = FitEllipseSubsample(im,template,threshold,r,t)

% 6 September 2016
%
% For a binary image im and 'template' over which to choose points to 
% subsample, picks points to subsample inside the template, and fits an 
% ellipse to im at each of these points. threshold is the maximum number of
% pixels at which we want to compute ellipsoids, usually 10000. r is the
% radius of the ball we use for ellipsoid fitting. t is the timestep
% corresponding to the current image, so that the radius and axis lengths
% can be scaled to be consistent with image resolutions. 

if t == 1 || t == 2
    scale_factor = 2/5;
    scale_factor_inv = 5/2;
else
    scale_factor = 1;
    scale_factor_inv = 1;
end

S = sum(sum(template));
if S <= threshold
    p = 1;
else
    p = threshold/S;
end
[row,col] = find(template);
L = length(row);
ellipses = zeros(L,8);
m = 0;
for l = 1:L
    k = rand;
    if k <= p
        m = m+1;
        xcoord = col(l);
        ycoord = row(l);
        [C,V1,V2,lgths] = FitEllipseAtP(im,scale_factor_inv*r,xcoord,ycoord);
        lgths = scale_factor*lgths;
        ellipses(m,:) = [C,V1,V2,lgths];
    end
end
ellipses = ellipses(1:m,:);
        
