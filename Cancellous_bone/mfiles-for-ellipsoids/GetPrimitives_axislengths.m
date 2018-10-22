function [prims,off_cnt] = GetPrimitives_axislengths(ellipsoids,subblock)

% 28 June 2016
%
% Computes the set of structural primitives for a rat sub-block from 
% information about ellipsoids fitted to that sub-block. ellipsoids is the 
% array with 15 columns and approximately 10000 rows, where the first three
% columns correspond to the centroid of the ellipsoid, the next nine
% columns correspond to the unit direction vectors of the major, middle and
% minor axes respectively, and the last three columns correspond to the
% lengths of the major, middle and minor axes respectively. subblock is the
% sub-block to which the ellipsoids have been fit. stepsize is the length
% of each step taken during subsampling.
%
% The program returns the array of approximately 10000 structural
% primitives. The first three columns correspond to the unit vector in the
% major direction. Columns 4-5 correspond to the unit vector in the middle 
% direction (with one element removed to avoid redundancies). The last 
% three columns are the lengths of the major, middle and minor axes 
% respectively. off_cnt is the number of ellipsoids for which the centre
% does not fall inside the bone volume.

[A,B,C] = size(subblock);
[N,~] = size(ellipsoids);
prims = zeros(N,8);
off_cnt = 0;
k = 0;
for n = 1:N
    primitive = zeros(1,8);
    ell = ellipsoids(n,:);
    C1 = ell(1);
    C2 = ell(2);
    C3 = ell(3);
    v1 = ell(4);
    v2 = ell(5);
    v3 = ell(6);
    u1 = ell(7);
    u2 = ell(8);
    l1 = ell(13);
    l2 = ell(14);
    l3 = ell(15);
    primitive(1) = v1;
    primitive(2) = v2;
    primitive(3) = v3;
    primitive(4) = u1;
    primitive(5) = u2;
    primitive(6) = l1;
    primitive(7) = l2;
    primitive(8) = l3;
    % Check if the centroid falls outside bone volume:
    rowcount = floor(C2)+1;
    colcount = floor(C1)+1;
    pgcount = floor(C3)+1;
    if rowcount<A && colcount<B && pgcount<C && ...
            subblock(rowcount,colcount,pgcount) == 0
        off_cnt = off_cnt+1;
    end
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
    
    
    
    