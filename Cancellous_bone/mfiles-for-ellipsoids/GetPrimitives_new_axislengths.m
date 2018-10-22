function prims = GetPrimitives_new_axislengths(ellipsoids)

% 18 July 2016
%
% Computes the set of structural primitives for a rat sub-block from 
% information about ellipsoids fitted to that sub-block. ellipsoids is the 
% array with 15 columns and approximately 10000 rows, where the first three
% columns correspond to the centroid of the ellipsoid, the next nine
% columns correspond to the unit direction vectors of the major, middle and
% minor axes respectively, and the last three columns correspond to the
% lengths of the major, middle and minor semi-axes respectively. 
%
% The program returns the array of approximately 10000 structural
% primitives. The first three columns correspond to the vector in the
% major direction, scaled by the length of the major axis. Columns 4-5
% correspond to the vector in the middle direction, scaled by the length of
% the middle axis. Column 6 corresponds to the vector in the minor
% direction, scaled by the length of the minor axis. All redundancies are
% removed.

[N,~] = size(ellipsoids);
prims = zeros(N,6);
k = 0;
for n = 1:N
    primitive = zeros(1,6);
    ell = ellipsoids(n,:);
    v1 = ell(4);
    v2 = ell(5);
    v3 = ell(6);
    u1 = ell(7);
    u2 = ell(8);
    w1 = ell(10);
    l1 = 2*ell(13);
    l2 = 2*ell(14);
    l3 = 2*ell(15);
    primitive(1) = l1*v1;
    primitive(2) = l1*v2;
    primitive(3) = l1*v3;
    primitive(4) = l2*u1;
    primitive(5) = l2*u2;
    primitive(6) = l3*w1;
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
    
    
    
    