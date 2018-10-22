function Hmat = AllTextonMapsSkel1(TextonMat)

% August 12 2014 (Rostock)
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
% the perticular row.
%
% The ordering of the rows is
% row 1 = rat 1, block 1; row 2 = rat 1, block 2; row 3 = rat 1, block 3;
% row 4 = rat 2, block 1; row 5 = rat 2, block 2; row 6 = rat 2, block 3;%
% etc.

% Set paths
sdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/my-FeatureArrays'];
hdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/my-mfiles'];

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
Hmat = zeros(90,NT);

for kR = 1:30       % counter for rats
    for kB = 1:3    % counter for sub-blocks
        
        % construct the name of input the file
        if kR < 10
            ratblock = ['rat0' int2str(kR) 'w08B' int2str(kB) 'skel1'];
        else
            ratblock = ['rat' int2str(kR) 'w08B' int2str(kB) 'skel1'];
        end
        
        % Load the input file. The array within the file is thetamat
        cd(sdir)
        eval(['load ' ratblock])
        cd(hdir)
        
        % Compute the texton map for the current sub-block
        [Tmap,Dvec] = TextonMap(TextonMat,thetamat);
        
        % Construct the histogram for the current sub-block
        Thist = hist(Tmap,NT);
        Thist = Thist/sum(Thist);
        
        % Store the histogram values in the output array
        kk = 3*(kR-1) + kB;
        Hmat(kk,:) = Thist;
    end
end
            