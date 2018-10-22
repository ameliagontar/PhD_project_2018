function [TextonArray,GrandFeatArray] = Textons4MergingExp4(NC)

% October 2 2014 (Rostock)
%
% This program is essentially the same as Textons4Merging.m used in
% group 3 experiments (but with filenames indicating experiment 2). Only
% the name of source directory was changed. 
%
% Aug 25 2014 (Rostock)
%
% This program performs essentially the same task as the program
% TextonKmeans.m except that the training texton assignments is kept for
% every feature vector in every block. This is for the purpose of
% implementing texton merging. 
%
% The output array TextonArray is of size NC*9 x 13 and lists all the
% textons for all the sub-blocks. 
%
% The output array GrandFeatArray is of size approx 500,000 x 14 and lists
% the feature vectors for all the selected on-voxels in all the blocks. The
% first column lists the texton to which the voxel belongs and columns 2:14
% record the 13 features representing the local thickness values at the
% voxel.
%
% Aug 12 2014
%
% Construct textons from feature arrays by k-means clustering. NC is the
% number of clusters used. 

% Set paths
sdir = ['~/Dropbox/Adir/Research/Groups/BoneGroup/remodelling/Textons3D/Combined13'];
hdir = ['~/Dropbox/Adir/Research/Groups/BoneGroup/remodelling/Textons3D/mfiles'];

% Load rat identification numbers for test and training sets. Columns:
% 1 = sham train,    2 = sham test
% 3 = ovx train,     4 = ovx test
% 5 = ovx+zol train, 6 = ovx+zol test
load Cohortmat

% For each of the nine sub-blocks (three sub-blocks per experimental group,
% collect the feature arrays for each training rat (5 rats) and compute NC
% textons for this block. The textons ares stored in TextonArray. This is a
% 3D array of size NC x 13 x 9 where each slice is the set of NC texton 
% coordinates for one of the 9 sub-blocks:
% TextonArray(:,:,1) = NC textons for sham block 1
% TextonArray(:,:,2) = NC textons for sham block 2
% ...
% TextonArray(:,:,9) = NC textons for ovx+zol block 3
tic

% TextonArray is of size 9NC x 13 where NC is the number of textons per
% sub-block. 
TextonArray = zeros(9*NC,13);

% GrandFeatArray is initially of size 500000 x 14. The first column
% stipulates the initial texton the vector has been assigned to. Once the
% merging process is underway, the value in the first column will be
% adjusted to reflect new texton membership. The remaining 13 columns list
% the 13 feature values. Once the GrandFeatArray has been filled, it will 
% be cropped to remove zero rows.
GrandFeatArray = zeros(500000,14);

GFArows = 0;  % index for the number of rows in GrandFeatArray used.
for kG = 1:3           % for the three experimental groups
    for kB = 1:3       % for each of the three blocks
        
        % Initialize the total feature array for the current block
        BlokFeatArray = zeros(60000,13);
        a = 1;
        
        for kR = 1:5   % for each of the five rats
            
            % Create names for loading files
            trank = 2*kG - 1;     % select indices for training sets
            ratid = Cohortmat(kR,trank);
            if ratid < 10
                InFile = ['rat0' int2str(ratid) 'w08B' int2str(kB)];
            else
                InFile = ['rat' int2str(ratid) 'w08B' int2str(kB)];
            end
            
            % Load the feature array for the current sub-block. The array
            % is called thetamat and is of size NV x 13, NV = # voxels.
            cd(sdir)
            eval(['load ' InFile])
            cd(hdir)
            
            % Construct the aggregate feature array over the five rats.
            [Ncur,m13] = size(thetamatC13);
            b = a + Ncur - 1;
            BlokFeatArray(a:b,:) = thetamatC13;
            %disp(['a = ' int2str(a) ',  b = ' int2str(b)])
            a = b+1;
        end
            
        % Remove zero rows at the end of the array BlokFeatArray and
        % find the textons for the current block over five training rats.
        BlokFeatArray = BlokFeatArray(1:b,:);

        [IDX,C,SUMD,D] = kmeans(BlokFeatArray,NC);
        sizeIDX = size(IDX);
        minIDX = min(IDX);
        maxIDX = max(IDX);
        [NV,m13] = size(BlokFeatArray);

        kT = 3*(kG-1) + kB; % current sub-block index (1,2,...,9).
        aa = NC*(kT - 1) + 1;
        bb = aa + NC - 1;
        
        % Store the textons from the current sub-block by appending to the
        % array TextonArray.
        TextonArray(aa:bb,:) = C;
        disp([' textons from block ' int2str(kT)])
        disp(C)
        
        % Store the feature vectors for the current block in the array
        % GrandFeatArray
        GFAa = GFArows+1;        % the first new row to be filled 
        GFAb = GFAa - 1 + b;     % the new last row to be filled
        GFArows = GFAb;          % update the rows counter
        GrandFeatArray(GFAa:GFAb,2:14) = BlokFeatArray;
        GrandFeatArray(GFAa:GFAb,1) = IDX + (NC*(kT-1));
        
    end
end

GrandFeatArray = GrandFeatArray(1:GFAb,:);

disp('For generating textons')
toc
