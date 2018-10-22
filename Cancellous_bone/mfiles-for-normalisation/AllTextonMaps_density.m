function Hmat = AllTextonMaps_density(TextonMat,tol)

% August 12 2014 (Rostock). Edited by Amelia 21 October 2015.
%
% This program uses the program TextonMap.m to construct texton maps for
% all blocks and all rats using the set of textons in TextonMat
%
% TextonMat is an array of size NT x NF where NT is the number of textons
% and NF is the number of features. This file is produced by the program
% TextonKmeans.m or program playing a similar role.
%
% Hmat is the array of histograms. Hmat is of size 90 x NT. Each row of
% Hmat lists the normalized histogram values for the block associated with
% the particular row.
%
% The ordering of the rows is
% row 1 = rat 1, block 1; row 2 = rat 1, block 2; row 3 = rat 1, block 3;
% row 4 = rat 2, block 1; row 5 = rat 2, block 2; row 6 = rat 2, block 3;%
% etc.

% Set paths
sdir1 = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/FeatureArrays'];
sdir2 = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/RatData'];
hdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles-for-normalisation'];

% remove after development
%    NC = 6
%    AllTextons2D = zeros(NC*9,13);
%    for ka = 1:9
%        a = (ka-1)*NC + 1;
%        b = ka*NC;
%        AllTextons2D(a:b,:) = TextonMat(:,:,ka);
%    end
%    TextonMat = AllTextons2D;

% Initialize the output array
[NT,m13] = size(TextonMat);
Hmat = zeros(90,NT+1);

avec = [1 101 201];
L = 99;

for kR = 1:30       % counter for rats
    for kB = 1:3    % counter for sub-blocks
        
        % construct the name of input the file
        if kR < 10
            ratblock = ['rat0' int2str(kR) 'w08B' int2str(kB)];
        else
            ratblock = ['rat' int2str(kR) 'w08B' int2str(kB)];
        end
        
        % Load the input file. The array within the file is thetamat
        cd(sdir1)
        eval(['load ' ratblock])
        cd(hdir)
        
        % Amelia: now need to normalise each row in thetamat.
        [V W] = size(thetamat);
        for v = 1:V
            feature_vector = thetamat(v,:);
            s = std(feature_vector);
            if s < tol
                fvec_new = feature_vector - mean(feature_vector);
            else
                fvec_new = (feature_vector - mean(feature_vector))/s;
            end
            thetamat(v,:) = fvec_new;
        end 
        
        % Compute the texton map for the current sub-block
        [Tmap,Dvec] = TextonMap(TextonMat,thetamat);
        
        % Construct the histogram for the current sub-block
        Thist = hist(Tmap,NT);
        
        % Compute the density for the current sub-block
        % Load the sub-block itself. The array is called x. The current
        % sub-block is curB.
        if kR < 10
            ratdata = ['rat0' int2str(kR) 'w08'];
        else
            ratdata = ['rat' int2str(kR) 'w08'];
        end
        
        cd(sdir2)
        eval(['load ' ratdata])
        cd(hdir)
        
        a = avec(kB);
        curB = x(:,:,a:a+L);
        vol_bone = sum(sum(sum(curB)));
        [R C P] = size(curB);
        vol_block = R*C*P;
        D = vol_bone/vol_block;
        
        Thist = Thist/sum(Thist);
        
        Thist_density = [Thist,D];
        
        %Thist_density = Thist_density/sum(Thist_density);
        
        % Store the histogram values in the output array
        kk = 3*(kR-1) + kB;
        Hmat(kk,:) = Thist_density;
    end
end
            