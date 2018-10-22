function R = FindRadiusR(im)

% 25 October 2016
%
% For an image im, finds the radius R as defined in Binder 2015. i.e. R is
% the radius of the circle for which the yeast colony fits entirely inside
% the circle. 

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
R = max(distances);