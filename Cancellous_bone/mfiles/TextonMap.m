function [Tmap,Dvec] = TextonMap(TextArray,VoxArray)

% August 1 2014 (Rostock)
%
% This program finds the 'texton map' in the context of the 3D textons for
% characterising bone structure. 
%
% TextArray is the array of aggregate cluster centres (textons) from all 
% groups. This array is of size NT x NF, where 
% NT = the number of textons 
% NF = the number of featues (NF = 13 during development)
%
% VoxArray is the array of size NV x NF listing the feature values for all
% the voxels in all the groups under consideration. 
% NV = the number of voxels 
%
% Tmap, is the vector of size NV x 1 listing the cluster (texton) 
% assignment of each voxel.
% 
% Dvec is a vector of size NV x 1 listing the distance of the voxel to the
% closest texton.
%
% If voxels are to be excluded due to being anomalous, this is done in a
% later step with a separate program.

% Identify the number of clusters and the number of features.
[NC,NF] = size(TextArray);

% Identify the number of voxels
[NV,NF] = size(VoxArray);

% Inialize DistArray of size NV x NC to hold the distance from each voxel
% to each texton. This is a temporary file, not an output file.
DistArray = zeros(NV,NC);
onevec = ones(NV,1);

% Compute distance to all the textons
for k = 1:NC
    
    % the current texton
    curtexton = TextArray(k,:);
    %sizecurtexton = size(curtexton)
    
    % difference vectors for all vexols and the current texton
    Diff1 = VoxArray - onevec*curtexton;
    
    % difference vectors 2-norm squared
    Diff2 = Diff1.^2;
    %sizediff = size(Diff2)
    
    % the 2-norms of the difference vectors
    Distvec = sum(Diff2');
    %sizeDistvec = size(Distvec)
    
    % enter distance from voxels to current texton
    DistArray(:,k) = sqrt(Distvec');
    %sizeDistArray = size(DistArray)
    
end

[Dvec,Tvec] = min(DistArray');
Dvec = Dvec';
Tmap = Tvec';



