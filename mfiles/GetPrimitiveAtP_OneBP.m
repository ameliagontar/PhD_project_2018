function v_p = GetPrimitiveAtP_OneBP(im,P,d,s)

% 23 January 2017
%
% A program that computes one primitive vector, at the point P. Assumes
% that the input data is a binary 3D array. The primitive is of the form
% v_p = (l_1,...,l_d,l_(d+1)), where the first d elements are thicknesses 
% of the object (marbling) within the slice in d directions, and l_(d+1) is
% the thickness of the object (marbling) between slices. The resolution of 
% the data is considered. OneBP means that we are measuring in only one 
% direction between slices. We may choose the number of directions we
% measure in within the slice.
%
% im is the original binary image. P is the voxel at which we want to make
% the thickness measurements. It is a triple in (row, column, page) form. 
% d is the number of directions. s is the step size for making thickness 
% measurements. v_p is the primitive vector at P.

[A,B,C] = size(im);
prim = zeros(1,d+1);
r = P(1);
c = P(2);
p = P(3);

% Find all thicknesses within slice:
for k = 1:d
    theta = (k-1)*(pi/d);
    xstep = sin(theta);
    ystep = cos(theta);
    rvox = r;
    cvox = c;
    pvox = p;
    xcoord = c-0.5;
    ycoord = r-0.5;
    step_cnt_p = 0;
    while rvox >= 1 && rvox <= A && cvox >= 1 && cvox <= B && pvox >= 1 ...
            && pvox <= C && im(rvox,cvox,pvox) == 1
        xcoord = xcoord+s*xstep;
        ycoord = ycoord+s*ystep;
        step_cnt_p = step_cnt_p+1;
        rvox = floor(ycoord)+1;
        cvox = floor(xcoord)+1;
    end
    rvox = r;
    cvox = c;
    pvox = p;
    xcoord = c-0.5;
    ycoord = r-0.5;
    step_cnt_n = 0;
    while rvox >= 1 && rvox <= A && cvox >= 1 && cvox <= B && pvox >= 1 ...
            && pvox <= C && im(rvox,cvox,pvox) == 1
        xcoord = xcoord-s*xstep;
        ycoord = ycoord-s*ystep;
        step_cnt_n = step_cnt_n+1;
        rvox = floor(ycoord)+1;
        cvox = floor(xcoord)+1;
    end
    step_cnt = step_cnt_p+step_cnt_n;
    prim(k) = s*step_cnt;
end

% Find thickness between slices (in one direction, measured in the z
% direction):
rvox = r;
cvox = c;
pvox = p;
zcoord = p-0.5;
step_cnt_p = 0;
while rvox >= 1 && rvox <= A && cvox >= 1 && cvox <= B && pvox >= 1 && ...
        pvox <= C && im(rvox,cvox,pvox) == 1
    zcoord = zcoord+s;
    step_cnt_p = step_cnt_p+1;
    pvox = floor(zcoord)+1;
end
pvox = p;
zcoord = p-0.5;
step_cnt_n = 0;
while rvox >= 1 && rvox <= A && cvox >= 1 && cvox <= B && pvox >= 1 && ...
        pvox <= C && im(rvox,cvox,pvox) == 1
    zcoord = zcoord-s;
    step_cnt_n = step_cnt_n+1;
    pvox = floor(zcoord)+1;
end
step_cnt = step_cnt_p+step_cnt_n;
prim(d+1) = s*step_cnt;
    
% Convert all thickness measurements to absolute lengths, to account for
% the difference in resolution between planes vs within each plane. This
% only applies to the steak marbling data set:
prims_within = (1/7)*prim(1:d);
prims_between = 4*prim(d+1);
v_p = [prims_within,prims_between];
    
        
        
        



