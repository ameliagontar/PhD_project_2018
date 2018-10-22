function [prims,off_cnt] = GetPrimitives_only_bonelengths(ellipsoids,subblock,stepsize)

% 24 August 2016
%
% Computes the set of structural primitives for a rat sub-block from 
% information about ellipsoids fitted to that sub-block. ellipsoids is the 
% array with 15 columns and approximately 10000 rows, where the first three
% columns correspond to the centroid of the ellipsoid, the next nine
% columns correspond to the unit direction vectors of the major, middle and
% minor axes respectively, and the last three columns correspond to the
% lengths of the major, middle and minor semi-axes respectively. subblock 
% is the sub-block to which the ellipsoids have been fit. stepsize is the 
% length of each step taken during subsampling.
%
% The program returns the array of approximately 10000 structural
% primitives of length 3. The columns correspond to the length of the bone 
% segment in the major, middle, and minor directions. off_cnt is the number
% of ellipsoids that falls outside of the bone. 

[A,B,C] = size(subblock);
[N,~] = size(ellipsoids);
prims = zeros(N,3);
off_cnt = 0;
for n = 1:N
    primitive = zeros(1,3);
    ell = ellipsoids(n,:);
    C1 = ell(1);
    C2 = ell(2);
    C3 = ell(3);
    v1 = ell(4);
    v2 = ell(5);
    v3 = ell(6);
    u1 = ell(7);
    u2 = ell(8);
    u3 = ell(9);
    w1 = ell(10);
    w2 = ell(11);
    w3 = ell(12);
    % Check if centroid falls outside bone:
    x = C1;
    y = C2;
    z = C3;
    rowcount = floor(y)+1;
    colcount = floor(x)+1;
    pgcount = floor(z)+1;
    if rowcount>0 && rowcount<=A && colcount>0 && colcount<=B && ...
            pgcount>0 && pgcount<=C && ...
            subblock(rowcount,colcount,pgcount) == 0
        off_cnt = off_cnt+1;
    end
    % Find length in major direction:
    step_cnt_p = 0;
    while rowcount>0 && rowcount<=A && colcount>0 && colcount<=B && ...
            pgcount>0 && pgcount<=C && ...
            subblock(rowcount,colcount,pgcount) == 1
        x = x+stepsize*v1;
        y = y+stepsize*v2;
        z = z+stepsize*v3;
        rowcount = floor(y)+1;
        colcount = floor(x)+1;
        pgcount = floor(z)+1;
        step_cnt_p = step_cnt_p+1;
    end
    x = C1;
    y = C2;
    z = C3;
    rowcount = floor(y)+1;
    colcount = floor(x)+1;
    pgcount = floor(z)+1;
    step_cnt_n = 0;
    while rowcount>0 && rowcount<=A && colcount>0 && colcount<=B && ...
            pgcount>0 && pgcount<=C && ...
            subblock(rowcount,colcount,pgcount) == 1
        x = x-stepsize*v1;
        y = y-stepsize*v2;
        z = z-stepsize*v3;
        rowcount = floor(y)+1;
        colcount = floor(x)+1;
        pgcount = floor(z)+1;
        step_cnt_n = step_cnt_n+1;
    end
    step_cnt = step_cnt_p+step_cnt_n;
    length_major = stepsize*step_cnt;
    % Find length in middle direction:
    x = C1;
    y = C2;
    z = C3;
    rowcount = floor(y)+1;
    colcount = floor(x)+1;
    pgcount = floor(z)+1;
    step_cnt_p = 0;
    while rowcount>0 && rowcount<=A && colcount>0 && colcount<=B && ...
            pgcount>0 && pgcount<=C && ...
            subblock(rowcount,colcount,pgcount) == 1
        x = x+stepsize*u1;
        y = y+stepsize*u2;
        z = z+stepsize*u3;
        rowcount = floor(y)+1;
        colcount = floor(x)+1;
        pgcount = floor(z)+1;
        step_cnt_p = step_cnt_p+1;
    end
    x = C1;
    y = C2;
    z = C3;
    rowcount = floor(y)+1;
    colcount = floor(x)+1;
    pgcount = floor(z)+1;
    step_cnt_n = 0;
    while rowcount>0 && rowcount<=A && colcount>0 && colcount<=B && ...
            pgcount>0 && pgcount<=C && ...
            subblock(rowcount,colcount,pgcount) == 1
        x = x-stepsize*u1;
        y = y-stepsize*u2;
        z = z-stepsize*u3;
        rowcount = floor(y)+1;
        colcount = floor(x)+1;
        pgcount = floor(z)+1;
        step_cnt_n = step_cnt_n+1;
    end
    step_cnt = step_cnt_p+step_cnt_n;
    length_middle = stepsize*step_cnt;
    % Find length in minor direction:
    x = C1;
    y = C2;
    z = C3;
    rowcount = floor(y)+1;
    colcount = floor(x)+1;
    pgcount = floor(z)+1;
    step_cnt_p = 0;
    while rowcount>0 && rowcount<=A && colcount>0 && colcount<=B && ...
            pgcount>0 && pgcount<=C && ...
            subblock(rowcount,colcount,pgcount) == 1
        x = x+stepsize*w1;
        y = y+stepsize*w2;
        z = z+stepsize*w3;
        rowcount = floor(y)+1;
        colcount = floor(x)+1;
        pgcount = floor(z)+1;
        step_cnt_p = step_cnt_p+1;
    end
    x = C1;
    y = C2;
    z = C3;
    rowcount = floor(y)+1;
    colcount = floor(x)+1;
    pgcount = floor(z)+1;
    step_cnt_n = 0;
    while rowcount>0 && rowcount<=A && colcount>0 && colcount<=B && ...
            pgcount>0 && pgcount<=C && ...
            subblock(rowcount,colcount,pgcount) == 1
        x = x-stepsize*w1;
        y = y-stepsize*w2;
        z = z-stepsize*w3;
        rowcount = floor(y)+1;
        colcount = floor(x)+1;
        pgcount = floor(z)+1;
        step_cnt_n = step_cnt_n+1;
    end
    step_cnt = step_cnt_p+step_cnt_n;
    length_minor = stepsize*step_cnt;
    % Fill in the components of the primitive vector E^p:
    primitive(1) = length_major;
    primitive(2) = length_middle;
    primitive(3) = length_minor;
    % Add E^p to the array of primitives for the entire sub-block:
    prims(n,:) = primitive;
end
    
    
    
    