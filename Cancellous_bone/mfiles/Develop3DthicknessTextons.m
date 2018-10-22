function thetamat = Develop3DthicknessTextons

% July 17, 2014 (Rostock)
%
% This is the first attempt to compute 3D oriented thickness features to
% use as features for texton analysis of 3D structure. Documentation
% describing the method appears in Notes.tex for this project.
%
% The output array is thetamat. This array is of size N1 x numD, where N1
% is the number of "on" voxels and numD is the number of directions (number
% of orientations). The entry at position m,n is the thickness at voxel m
% in direction n.

% Construct a test block, B
B = zeros(21,21,21);
B(10:12,9:13,7:15) = ones(3,5,9);

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
 
 % The array of unit direction vectors is DirN
 Dir2 = Dirmat.^2;
 NormDirVec = (sqrt(sum(Dir2')))';
 NormDirMat = NormDirVec*[1 1 1];
 DirN = Dirmat./NormDirMat;
 [numD,s] = size(DirN);     % numD is the number of orientations

% Set the maximum search distance along oriented lines
maxk = 5;

% Find the voxels in B with value 1
Bvec = B(:);
ID1 = find(Bvec == 1);
N1 = length(ID1);

% Initialise the output array thetamat. 
thetamat = zeros(N1,numD);

% Extract thickness for each "on" voxel (voxels p in B with B(p) = 1) 
% k is the index for the on voxels
for k = 1:N1
    pID = ID1(k) ;                    % index of current on voxel p
    [p1,p2,p3] = ind2sub(sizeB,pID);  % current voxel in coordinates
    
    % For each direction, look for the on pixels connected to p. The index
    % kd counts the orientations.
    for kd = 1:numD
        NDvec = DirN(kd,:);      % current normalised orientation vector
        
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
        
        % record the thickness at voxel k in direction kd 
        thetamat(k,kd) = k1 + k2 - 1;
        
    end
end
            
                
       
    

