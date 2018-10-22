function TextonArray = TextonKmeans_random(NC)

% Edited by Amelia 13 April 2016
% Aug 12 2014
%
% Construct textons from feature arrays by k-means clustering. NC is the
% number of clusters used. 

% Set paths
sdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/FeatureArrays_random';
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles';

% Load rat identification numbers for test and training sets. Columns:
% 1 = sham train,    2 = sham test
% 3 = ovx train,     4 = ovx test
% 5 = ovx+zol train, 6 = ovx+zol test
load Cohortmat

% For each of the nine sub-blocks (three sub-blocks per experimental group),
% collect the feature arrays for each training rat (5 rats) and compute NC
% textons for this block. The textons ares stored in TextonArray. This is a
% 3D array of size NC x 13 x 9 where each slice is the set of NC texton 
% coordinates for one of the 9 sub-blocks:
% TextonArray(:,:,1) = NC textons for sham block 1
% TextonArray(:,:,2) = NC textons for sham block 2
% ...
% TextonArray(:,:,9) = NC textons for ovx+zol block 3
tic
TextonArray = zeros(NC,13,9);
for kG = 1:3           % for the three experimental groups
    for kB = 1:3       % for each of the three blocks
        
        % Initialize the total feature array for the current block
        TotFeatArray = zeros(60000,13);
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
            [Ncur,m13] = size(thetamat);
            b = a + Ncur - 1;
            TotFeatArray(a:b,:) = thetamat;
            %disp(['a = ' int2str(a) ',  b = ' int2str(b)])
            a = b+1;
        end
            
        % Remove zero rows at the end of the array TotFeatArray and
        % find the textons for the current block over five training rats.
        TotFeatArray = TotFeatArray(1:b,:);

        [IDX,C,SUMD,D] = kmeans(TotFeatArray,NC);
        [NV,m13] = size(TotFeatArray);

        kT = 3*(kG-1) + kB;
        TextonArray(:,:,kT) = C;
        disp([' textons from block ' int2str(kT)])
        disp(C)
    end
end
disp('For generating textons')
toc
