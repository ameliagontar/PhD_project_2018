function WithinDistMat = NumberOfTextons

% August `8, 2014 (Rostock)
%
% This program establishes the optimal number of textons for each of the
% nine sub-blocks that comprise the rat bone data: The experiemental groups
% and three sub-blocks per group. 
%
% To find the optimal number of textons, the method proposedin Hastie,
% Tibshrani and Friedmann (sp?) is used: for k clusters, compute the
% withing cluster distances for the data and for random data having the
% same range and number of points. Repeat for several k and adopt k for
% which the ratio of within cluster distances is greatest. Optimal clusters
% are based on the 5 rats designated to the training set as recorded in the
% file Cohortmat.mat. This is an array of size 5 x 6 and lists the
% membership of all rats to training and testing sets as follows. 
% column 1 = sham training rats       column 2 = sham testing rats
% column 3 = ovx training rats        column 4 = ovx testing rat
% column 5 = ovx+zol training rats    column 6 = ovx+zol testing rats

     
% Set paths
sdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/my-FeatureArrays'];
hdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles'];

% Load rat identification numbers for test and training sets. Columns:
% 1 = sham train,    2 = sham test
% 3 = ovx train,     4 = ovx test
% 5 = ovx+zol train, 6 = ovx+zol test
load Cohortmat

% NTvec =[2 4 6 8 10];        % WCDmat1.mat
NTvec = [1 7 13 19 25 31];    % WCDmat2.mat
NTvec = [1 61 81 101 121 141];
NS = length(NTvec);

% Initialise array for storing within cluster distances
WithinDistMat = zeros(2,NS);

for kS = 1:NS              % testing different numbers of clusters
    NC = NTvec(kS);
    for kG = 1:3           % for the three experimental groups
        for kB = 1:3       % for each of the three blocks
        
            tic
            disp(['Iteration ' int2str(kS) ' out of ' int2str(NS)])
            disp(['Group ' int2str(kG) ' ,   sub-block ' int2str(kB)])
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
            
            % Do the clustering and find the within cluster distances.
            % Repeat 5 times to obtain a mean value. Record the mean in the
            % array WithinDistMat
            WsumD = zeros(1,5);
            for kw = 1:5
                % Run the k-means clustering on the data
                [IDX,C,SUMD,D] = kmeans(TotFeatArray,NC,'MaxIter',200);
                % compute and record the within cluster sums for the data
                WsumD(kw) = sum(SUMD);
            end
            %rowcnt = 6*(kG-1) + 2*(kB-1) + 1;
            WithinDistMat(1,kS) = mean(WsumD);
             
            % Do the clustering for random data
            minvec = min(TotFeatArray);
            maxvec = max(TotFeatArray);
            RndFeatArray = zeros(size(TotFeatArray));
            for kc = 1:13
                minv = minvec(kc);
                maxv = maxvec(kc);
                RndFeatArray(:,kc) = minv + (maxv - minv)*rand(b,1);
                % Run the k-means clustering on random values
                [IDX,C,SUMD,D] = kmeans(RndFeatArray,NC,'MaxIter',200);
                % compute and record the within cluster sums for random
                WsumR(kw) = sum(SUMD);
            end
            %rowcnt = 6*(kG-1) + 2*kB;
            WithinDistMat(2,kS) = mean(WsumR);
           
            toc
        end
    end
end


% ViewWCDmat(NTvec,WithinDistMat)

