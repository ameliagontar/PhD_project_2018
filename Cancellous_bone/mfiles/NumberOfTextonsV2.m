function [WithinDistMat,NTvec] = NumberOfTextonsV2(kG,kB)

% August 19, 2014 (Rostock)
%
% The previous version ran too slowly to be of practical use. One problem
% is that the optimal number of clusters seems to be very large and k-means
% struggles to converge when there are very many clusters. Here the same
% compuations are performed, but the strategy is differet. First, only
% single block is consdered at a time. Also, the number of trials is
% reduced from 5 to NW. The idea is to find at least a crude estimate of the
% number of clusters that are optimal and then investigate near this number
% in more detail. This program only provides the crude estimates.
%
% August 18, 2014 (Rostock)
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
sdir = ['~/Dropbox/Adir/Research/Groups/BoneGroup/remodelling/Textons3D/FeatureArrays'];
hdir = ['~/Dropbox/Adir/Research/Groups/BoneGroup/remodelling/Textons3D/mfiles'];

% set the number of samples per sub-block
NW = 1;

% Load rat identification numbers for test and training sets. Columns:
% 1 = sham train,    2 = sham test
% 3 = ovx train,     4 = ovx test
% 5 = ovx+zol train, 6 = ovx+zol test
load Cohortmat

%NTvec = [1 41 81 121 161 201 241 281 320];  % V1 best 281
%NTvec = [261 301 341 381];                  % V2 
%NTvec = [451 551 651 751];                  % V3
%NTvec = [1000 1500];                        % V4
%NTvec = [3000];                             % V5
%NTvec = [6000];                             % V6
NTvec = [20000];

NS = length(NTvec);

% Initialise array for storing within cluster distances
WithinDistMat = zeros(2,NS);

for kS = 1:NS              % testing different numbers of clusters
    NC = NTvec(kS);
    %for kG = 1:3           % for the three experimental groups
        %for kB = 1:3       % for each of the three blocks
        
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
            % Repeat NW times to obtain a mean value. Record the mean in the
            % array WithinDistMat
            WsumD = zeros(1,NW);
            for kw = 1:NW
                % Run the k-means clustering on the data
                [IDX,C,SUMD,D] = kmeans(TotFeatArray,NC,'MaxIter',200);
                % compute and record the within cluster sums for the data
                WsumD(kw) = sum(SUMD);
            end
            %rowcnt = 6*(kG-1) + 2*(kB-1) + 1;
            WithinDistMat(1,kS) = mean(WsumD);
             
            % Do the clustering for random data
            
            % First construct the random data
            minvec = min(TotFeatArray);
            maxvec = max(TotFeatArray);
            RndFeatArray = zeros(size(TotFeatArray));
            for kc = 1:13
                minv = minvec(kc);
                maxv = maxvec(kc);
                RndFeatArray(:,kc) = minv + (maxv - minv)*rand(b,1);
            end
            
            WsumR = zeros(1,NW);
            for kw = 1:NW
                % Run the k-means clustering on random values
                [IDX,C,SUMD,D] = kmeans(RndFeatArray,NC,'MaxIter',200);
                % compute and record the within cluster sums for random
                WsumR(kw) = sum(SUMD);
            end
            %rowcnt = 6*(kG-1) + 2*kB;
            WithinDistMat(2,kS) = mean(WsumR);
           
            toc
        %end
    %end
end
disp(' ')
disp(['Group ' int2str(kG) ',  sub-block ' int2str(kB)])

Trudat = log(WithinDistMat(1,:));
Randat = log(WithinDistMat(2,:));
max1 = max(max(Trudat),max(Randat));
Trudat = Trudat/max1;
Randat = Randat/max1;

plot(NTvec,Trudat,'b')
hold on
plot(NTvec,Randat,'r')
hold off

Diffvec = Randat - Trudat;
[maxD,bestID] = max(Diffvec);
disp(['Best number of clusters = ' int2str(NTvec(bestID))])


%ViewWCDmat(NTvec,WithinDistMat)

