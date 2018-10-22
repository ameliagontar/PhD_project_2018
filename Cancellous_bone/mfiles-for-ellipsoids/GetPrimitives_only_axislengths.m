function prims = GetPrimitives_only_axislengths(ellipsoids)

% 24 August 2016
%
% Computes the set of structure primitives for a rat sub-block from 
% information about ellipsoids fitted to that sub-block. ellipsoids is the 
% array with 15 columns and approximately 10000 rows, where the first three
% columns correspond to the centroid of the ellipsoid, the next nine
% columns correspond to the unit direction vectors of the major, middle and
% minor axes respectively, and the last three columns correspond to the
% lengths of the major, middle and minor semi-axes respectively.
%
% The program returns the array of approximately 10000 structure
% primitives. The primitives are of length 3, and comprise the lengths of
% the major, middle and minor axes respectively. This is intended to be for
% a rotation invariant version of the ellipsoid experiment, where all
% directional information is removed.

[N,~] = size(ellipsoids);
prims = zeros(N,3);
k = 0;
for n = 1:N
    primitive = zeros(1,3);
    ell = ellipsoids(n,:);
    l1 = 2*ell(13);
    l2 = 2*ell(14);
    l3 = 2*ell(15);
    primitive(1) = l1;
    primitive(2) = l2;
    primitive(3) = l3;
    % Discard any primitives that contain NaNs or Inf. These come from one
    % of the eigenvalues = 0.
    nantest = sum(isnan(primitive));
    inftest = sum(isinf(primitive));
    test = nantest+inftest;
    if test == 0
        k = k+1;
        prims(k,:) = primitive;
    end
end
prims = prims(1:k,:);
    
    
    
    