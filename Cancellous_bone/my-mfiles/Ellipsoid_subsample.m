function ellipsoids = Ellipsoid_subsample(vol,N,radius)

% 10 May 2016
%
% Subsamples multiple points from a binary volume. Around each point, draws
% a ball, finds the largest connected component inside the ball, and fits 
% an ellipsoid to this connected component. 
%
% vol is a binary volume, not necessarily connected. N is the number of
% voxels that we want to subsample at (note we will not subsample at
% exactly N voxels, since the choice of voxels will be stochastic). radius
% is the radius of the balls we are initialising at each point.
%
% ellipsoids is a cell containing the following information: coordinate of
% the centroid, eigenvectors as column vectors in a 3x3 matrix, and lengths
% of the major, middle and minor axes.

p = N/sum(sum(sum(vol)));
on_voxels = find(vol);
L = length(on_voxels);
ellipsoids = cell(L,3);
m = 0;
for l = 1:L
    k = rand;
    if k < p
        m = m+1;
        idx = on_voxels(l);
        [y1,x1,z1] = ind2sub(size(vol),idx);
        [centroid,V,le1,le2,le3] = Ellipsoid_fitball(vol,x1,y1,z1,radius);
        lgths = [le1,le2,le3];
        ellipsoids{m,1} = centroid;
        ellipsoids{m,2} = V;
        ellipsoids{m,3} = lgths;
    end
end
ellipsoids = ellipsoids(1:m,:);