function thetamat = ThicknessFeatures4or13(B,maxk,M,ssf)

% July 21, 2014 (Rostock)
%
% thetamat = ThicknessFeatures4or13(B,maxk,M,ssf);
%
% B is a binary 3D array. Let C denote the set of "on" voxels of B, meaning
% the set of voxels with value 1. For every voxel p in C, and orientation
% theta_i, the maximum length of the line segment containing the voxel p, 
% having orientation theta_i and lying entirely within C is recorded as
% feature i at p. There are 13 orientations and so a voxel p in C is
% initially represented by a feature vector of length 13. 
% 
% The imput parameter maxk limits the length of the line segment. The 
% longest line segment allowed is of length 2*maxk + 1. The recommended 
% value for the rat bone data is maxk = 50 (allowing line segments of 101
% voxels).
%
% The input parameter M dictates the number of orientations reported. The
% value of M must be either 4 or 13. In both cases, orientation in 13
% directions are computed. If M = 13, all 13 orientations are recorded in 
% output file thetamat. In this case, thetamat is of size N1 x 13, where N1
% is the number of voxels in C considered. If M = 4, some orientations are
% combined into 4 sets of orientations determined by their orientation with
% respect to the long axis of the bone. In this case, thetamat is of size
% N1 x 4. The oritentations are combined as follows. The default value for
% M is 13.
%
% d1 is the combination of orientations 1, 2, 3, 4. These are the 
% orientations v with v.u13 = 0, where u13 is orientation 13, the one along 
% the axis of the bone. In other words, these are the vectors perpendicular 
% to the axis of the bone. Note that here the orientations are given by
% unit vectors.
%
% d2 is the combination of orientations 5, 6, 7, 8. These are the
% orientations v with |v.u13| = 1/sqrt(2).
%
% d3 is the combination of orientations 9, 10, 11, 12. These are the
% orientations v with |v.u13| = 1/sqrt(3). 
%
% d4 is just orientation u13.
% 
% The input parameter ssf determines the proportion of voxels in C for
% which the oriented thickness values are found. This is included since for
% a single block of data from the rat bone project there may be 5 million
% on voxels. Computing the oriented thickness for all of these is
% computationally very expensive. By setting ssf = .01, for example,
% reduces the number by a factor of 100. The parameter ssf gives the
% probability of each on pixel being selected. Hence the final number is
% not quite predictable from the onset.
%
% To avoid testing points outside B (and so obtaining an error for
% subscripts being out of bounds), the block B is embedded in a larger 
% block of zeros. The layer of zeros surrounding B ensures that line 
% searches terminate before exiting B.

% The program stars here

% Record the size of the block and embed the block in a larger block of
% zeros.
[b1,b2,b3] = size(B);
Bbig = zeros(b1+2,b2+2,b3+2);
Bbig(2:b1+1,2:b2+1,2:b3+1) = B;
B = Bbig;
sizeB = size(B);

% Construct the array of direction vectors.
% The directions given by voxel displacement are in Dirmat
Dirmat = [
     1  0  0;  % theta_01
     0  1  0;  % theta_02
     1  1  0;  % theta_03
     1 -1  0;  % theta_04
     1  0  1;  % theta_05
    -1  0  1;  % theta_06
     0  1  1;  % theta_07
     0 -1  1;  % theta_08
     1  1  1;  % theta_09
    -1  1  1;  % theta_10
     1 -1  1;  % theta_11
    -1 -1  1;  % theta_12
     0  0  1]; % theta_13
 
% Normalize the direction vectors in Dirmat. The array of unit direction 
% vectors is DirN.
Dir2 = Dirmat.^2;
NormDirVec = (sqrt(sum(Dir2')))';
NormDirMat = NormDirVec*[1 1 1];
DirN = Dirmat./NormDirMat;

% Find the voxels in B with value 1.
Bvec = B(:);
ID1 = find(Bvec == 1);
N1 = length(ID1);           % N1 is the number of 'on' voxels

% Estimate the number of voxels actually visited and pad this number to
% allow for under-estimates. This is done to initialize the output array.
EN = ceil(ssf*N1);
EN1 = ceil(1.1*EN);

% Initialise the output array thetamat. 
thetamat = zeros(EN1,13);

% Extract the thickness for each p in C (voxels p in B with B(p) = 1). 
% k is the index for the on voxels.
truk = 0;
for k = 1:N1
    rndp = rand;
    if rndp < ssf 
        truk = truk + 1;
        pID = ID1(k);                     % index of current on voxel p
        [p1,p2,p3] = ind2sub(sizeB,pID);  % current voxel in coordinates
        %disp(['p = ' int2str([p1,p2,p3])])
    
        % For each direction, look for the on pixels connected to p. The 
        % index kd counts the orientations.
        % for kd = 1:13
        for kd = 1:13
            NDvec = DirN(kd,:);     % current normalised orientation vector
        
            % test voxels in direction NDvec for being on or not
            flg = 0;
            k1 = 0;
            while flg == 0
                k1 = k1 + 1;
                if k1 > maxk
                    flg = 1;
                end
                q = round([p1 p2 p3] + k1*NDvec);  % current voxel to test
                if B(q(1),q(2),q(3)) == 0;
                    flg = 1;
                end
            end
        
            % test voxels in direction -NDvec for being on or not
            flg = 0;
            k2 = 0;
            while flg == 0
                k2 = k2 + 1;
                if k2 > maxk
                    flg = 1;
                end
                q = round([p1 p2 p3] - k2*NDvec);  % current voxel to test
                if B(q(1),q(2),q(3)) == 0;
                    flg = 1;
                end
            end
        
            % Record the thickness at voxel k in direction kd in terms of 
            % the number of steps.
            steps = k1 + k2 - 1;
        
            % Record the thickness at voxel k in direction kd in terms of
            % physical length.
            thetamat(truk,kd) = steps;
        
        end
    end
end
     
%disp(['actual number of voxels sampled = ' int2str(truk)])
thetamat = thetamat(1:truk,:);

% Combine the orientations if M = 4.
if M == 4
    tempmat = zeros(truk,4);
    t1 = (max(thetamat(:,1:4)'))';
    tempmat(:,1) = t1;
    t2 = (max(thetamat(:,5:8)'))';
    tempmat(:,2) = t2;
    t3 = (max(thetamat(:,9:12)'))';
    tempmat(:,3) = t3;
    tempmat(:,4) = thetamat(:,13);
    thetamat = tempmat;
end


    
    
    tempmat(:,1) = thetamat(:,1) + thetamat(:,2) + thetamat(:,3) + thetamat(:,4);
    
    