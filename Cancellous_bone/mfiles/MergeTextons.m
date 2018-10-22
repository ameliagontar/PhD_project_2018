function [GrandFeatArray,TextonArray] = MergeTextons(GrandFeatArray,TextonArray,lambda)

% August 25 2014 (Rostock)
%
% This program performs texton merging. The idea is to merge textons that
% are likely to represent the same local texture pattern. This program
% performs one merge or no mergings. The idea is to run this program until
% a pre-set maximum number of mergings have been made or if no further
% mergings are found.
%
% The input file GrandFeatArray is constructed by Textons4Merging.m and is
% an array of size TF x 14, where TF denots the number of points in the
% representation space (vectors of local patterns associated with
% on-voxels). The first column lists the texton assigned to the vector and
% the columns 2:14 list the 13 thickness values.
%
% The input file TextonArray is also constructed by Texons4Merging.m and is
% of size NT x 13, where NT is to initial number of textons (clusters). The
% columns list the thickness feature values for the centers of these
% clusters.
%
% The output array NewTextons is of size NMT x 13, where NMT = is the new 
% number of textons. NMT = NT or NMT = NT - 1. The output array NewFeats is
% the same size as GrandFeatArray but the indexing column (column 1) is
% revised to reflect the new cluster memberships.
% 
% The merging criterion is not well established, but initially two clusters
% will be merged if 
%
% ||c1 - c2|| < lambda*min(SD1,SD2),
%
% where c1 and c2 are the cluster centers and SD1 and SD2 are the standard
% deviation of the clusters after projecting on the Fisher direction.

[NF,m14] = size(GrandFeatArray);
[NT,m13] = size(TextonArray);

INDvec = GrandFeatArray(:,1);

k1flag = 1;
k1cnt = 0;
while k1flag == 1
    k1cnt = k1cnt + 1;
    if k1cnt == NT-1;
        k1flag = 0;
    end
    
    % extract texton 1 and representation vectors beloning to T1
    T1 = TextonArray(k1cnt,:);
    Gvec1 = find(INDvec == k1cnt);
    G1 = GrandFeatArray(Gvec1,2:m14);
    
    k2flag = 1;
    k2cnt = k1cnt;
    while k2flag == 1
        k2cnt = k2cnt + 1;
        if k2cnt == NT;
            k2flag = 0;
        end
        % extract texton 2 and representation vectors belonging to T2
        T2 = TextonArray(k2cnt,:);
        Gvec2 = find(INDvec == k2cnt);
        G2 = GrandFeatArray(Gvec2,2:m14);
        
        % Find the Fisher direction for the two groups
        Fishvec = FisherDir(G1,G2);
        FishD = Fishvec/norm(Fishvec);
        
        % Project cluster onto the Fisher direction
        F1 = G1*FishD;
        F2 = G2*FishD;
        
        % Compute means and standard deviations 
        ave1 = mean(F1);
        ave2 = mean(F2);
        std1 = std(F1);
        std2 = std(F2);
        
        % test the merging criterion
        meandiff = abs(ave2 - ave1);
        minstd = lambda*min(std1,std2);
        if meandiff < minstd
            
            % set flags to terminate the program
            k1flag = 0;
            k2flag = 0;
            
            % Change indices of cluster 2 members to the index of cluster 1
            INDvec(Gvec2) = k1cnt*ones(size(Gvec2));
            
            % Reduce the index of cluster members with index > k2cnt by 1
            highind = find(INDvec > k2cnt);
            NewInd = INDvec(highind) - 1;
            INDvec(highind) = NewInd;
            
            % Reduce the texton array by one row by replacing the row k1cnt
            % by the weighted sum of the rows k1cnt and k2cnt, removing row
            % k2cnt, moving textons in rows greater than k2nt up the array
            % and removing the last row.
            L1 = length(Gvec1);
            L2 = length(Gvec2);
            newTexton = L1*TextonArray(k1cnt,:) + L2*TextonArray(k2cnt,:);
            newTexton = newTexton/(L1 + L2);
            TextonArray(k1cnt,:) = newTexton;
            if k2cnt < NT
                highblock = TextonArray(k2cnt+1:NT,:);
                TextonArray(k2cnt:NT-1,:) = highblock;
            end
            TextonArray = TextonArray(1:NT-1,:);
            
        end
    end
end
  
GrandFeatArray(:,1) = INDvec;

            
        
        
        