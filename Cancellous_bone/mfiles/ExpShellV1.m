function Harray = ExpShellV1

% August 1, 2014 (Rostock)
%
% Initial version of the program for running experiments on advanced
% textons. The output file Harray is of size 9 x NC*9. Each row is the
% normalised histogram of texton labels for a single sub-block. The rows
% are:
% 1 = sham sub-block 1, 2 = sham sub-block 2, 3 = sham sub-block 3 
% 4 = ovx sub-block 1,  5 = ovx sub-block 2,  6 = ovx sub-block 3
% 7 = zol sub-block 1,  8 = zol sub-block 2,  9 = zol sub-block 4
% Here, sub-block 1 is closest to the growth plate and 3 is the farthest.

% Set parameters
NC = 7;     % number of textons per sub-block (9*NC textons in total)
% Set paths
sdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/my-FeatureArrays'];
hdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles'];

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

% For this experiment, texton maps are created by assigning each voxel in
% each sub-block to one of the 9xNC textons in the total collection of
% textons (total texton dictionary). Hence the textons currently stored as
% a 3D array to separate the textons from different groups are combined
% into as single array. Note NC = number of clusters = number of textons
AllTextons2D = zeros(NC*9,13);
for ka = 1:9
    a = (ka-1)*NC + 1;
    b = ka*NC;
    AllTextons2D(a:b,:) = TextonArray(:,:,ka);
end

disp(' ')
disp(['all textons'])
disp(AllTextons2D)


% Assign voxels to textons and for each sub-block, construct a normalised
% histogram of texton frequencies.
Harray = zeros(9,NC*9);
figure(1)
for kG = 1:3           % for the three experimental groups
    for kB = 1:3       % for each of the three blocks
        Bcnt = 3*(kG-1) + kB;
        %subplot(3,3,Bcnt)
        for kR = 1:5   % for each of the five rats
            
            % Create names for loading files
            trank = 2*kG;     % select indices for testing sets
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
            
            % Find the texton map for the current sub-block
            %sizetextonarray = size(TextonArray)
            %sizevoxelarray = size(thetamat)
            %kT = 3*(kG-1) + kB;
            %curtextonarray = TextonArray(:,:,kT);
            %[Tmap,Dvec] = TextonMap(curtextonarray,thetamat);
            [Tmap,Dvec] = TextonMap(AllTextons2D,thetamat);
            
            % Construct the histogram for the current sub-block
            [NT,m13] = size(AllTextons2D);
            Thist = hist(Tmap,NT);
            Thist = Thist/sum(Thist);
            
            kT = 3*(kG-1) + kB;
            Harray(kT,:) = Thist;
            
            %binvec = 1:NT;
            %bar(binvec,Thist)
            
            %maxH = max(Thist);
            %axis([0 NT+1 0 .4])
            
        end
    end
end
            
% display the histograms for all sub-blocks and all three groups
[m9,NT] = size(Harray);

Gmat = [
    'sham';
    ' ovx';
    ' zol'];



for kG = 1:3
    for kB = 1:3
        
        kk = 3*(kG-1) + kB;
        subplot(3,3,kk)
        curH = Harray(kk,:);
        bar(curH)
        axis([0 NT+1 0 .14])
        
        if kG == 1
            title(['sub-block ' int2str(kB)],'fontsize',16)
        end
        if kB == 1;
            txtvec =[Gmat(kG,:)];
            text(-30,.08,txtvec,'fontsize',16)
        end
    end  
end
            
            
