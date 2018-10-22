function thetamat = ThicknessFeatures(B,maxk)

% July 21, 2014 (Rostock)
%
% B is a binary 3D array. Let C denote the set of "on" voxels of B, meaning
% the set of voxels with value 1. For every voxel p in C, and orientation
% theta_i, the maximum length of the line segment containing the voxel p, 
% having orientation theta_i and lying entirely within C is recorded as
% feature i at p. There are 13 orientations and so every voxel p is
% represented by a feature vector of length 13. 
%
% The output array is thetamat. This array is of size N1 x 13, where N1
% is the number of voxels in C. The entry at position p,i is the thickness 
% at voxel p in direction i.

% To avoid testing points outside B (and so obtaining an error for
% subscripts being out of bounds), the block B is embedded in a larger 
% block of zeros. The layer of zeros surrounding B ensures that line 
% searches terminate before exiting B.

% maxk is the maximum length parameter.

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
 [numD,s] = size(DirN);     % numD is the number of orientations

% Find the voxels in B with value 1.
Bvec = B(:);
ID1 = find(Bvec == 1);
N1 = length(ID1)

% subsampling
ssf = .01;
EN = ceil(ssf*N1)
EN1 = ceil(1.1*EN)

% Initialise the output array thetamat. 
thetamat = zeros(EN1,numD);

% Extract the thickness for each p in C (voxels p in B with B(p) = 1). 
% k is the index for the on voxels.
truk = 0;
for k = 1:N1
    rndp = rand;
    if rndp < ssf 
        truk = truk + 1;
        pID = ID1(k);                     % index of current on voxel p
        [p1,p2,p3] = ind2sub(sizeB,pID);  % current voxel in coordinates
    
        % For each direction, look for the on pixels connected to p. The 
        % index kd counts the orientations.
        for kd = 1:numD
            NDvec = DirN(kd,:);     % current normalised orientation vector
        
            % test voxels in direction NDvec for being on or not
            flg = 0;
            k1 = 0;
            while flg == 0
                k1 = k1 + 1;
                if k1 > maxk
                    flg = 1;
                end
                q = round([p1 p1 p3] + k1*NDvec);  % current voxel to test
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
     
disp(['actual number of voxels sampled = ' int2str(truk)])
thetamat = thetamat(1:truk,:);