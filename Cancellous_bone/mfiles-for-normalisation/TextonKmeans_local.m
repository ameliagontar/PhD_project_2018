function TextonArray = TextonKmeans_local(NC,tol)

% Aug 12 2014. Edited by Amelia 4 November 2015.
%
% Construct textons from feature arrays by k-means clustering. NC is the
% number of clusters used. tol is the tolerance for the standard deviation,
% used in the normalisation step.

% Set paths
sdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/FeatureArrays'];
hdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles-for-normalisation'];

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
TextonArray = zeros(NC,15,9);
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
        
        % Amelia: each of the rows in TotFeatArray needs to be normalised.
        % Also append the mean and std of the row to the end of each row.
        % These feature vectors theoretically have the same information
        % content, but structure and scale are separated at a local level.
        TotFeatArray_new = zeros(b,15);
        for m = 1:b
            feature_vector = TotFeatArray(m,:);
            mn = mean(feature_vector);
            s = std(feature_vector);
            if s < tol
                fvec_n = feature_vector - mean(feature_vector);
                fvec_new = [fvec_n,mn,s];
            else
                fvec_n = (feature_vector - mean(feature_vector))/s;
                fvec_new = [fvec_n,mn,s];
            end
            TotFeatArray_new(m,:) = fvec_new;
        end

        [IDX,C,SUMD,D] = kmeans(TotFeatArray_new,NC);
        [NV,m13] = size(TotFeatArray_new);

        kT = 3*(kG-1) + kB;
        TextonArray(:,:,kT) = C;
        disp([' textons from block ' int2str(kT)])
        disp(C)
    end
end
disp('For generating textons')
toc
