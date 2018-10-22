function CombineOrientations

% October 2 2014 (Rostock)
%
% This program extracts the local feature vectors produced by
% AllRats13Features.m that are stored in 
% ~/Dropbox/Adir/Research/Groups/BoneGroup/remodelling/Textons3D/FeatureArrays
% and converts them to new feature vectors with azimuth information
% removed.
%
% Three versions are constructed and stored. Suppose the original feature
% vector is vp = [ 16 2 12 3 15 17 4 9 15 4 5 9 18]. The new vectors are
%
% 1. feature vectors of length 13, where the four orientations of equal
% angle of elevation (with respect to orientation 13) are listed in
% inreasing order. For the example vector vp, the new vector is
% vp13 = [2 3 12 16 4 9 15 17 4 5 9 15 18]
%
% 2. feature vectors of length 7, where the mean and std of the four
% orientation of equal angle of elveation are listed. For the example
% vp7 = [8.25 6.85 11.25 5.91 11.75 5.85 18]
%
% 3. feature vectors of length 4, listing only the means. For the example
% vp4 = [8.25 11.29 11.75 18]

% set paths for directories
FAdir = ['~/Dropbox/Adir/Research/Groups/BoneGroup/remodelling/Textons3D/FeatureArrays'];
Hdir = ['~/Dropbox/Adir/Research/Groups/BoneGroup/remodelling/Textons3D/mfiles'];
C13dir = ['~/Dropbox/Adir/Research/Groups/BoneGroup/remodelling/Textons3D/Combined13'];
C7dir = ['~/Dropbox/Adir/Research/Groups/BoneGroup/remodelling/Textons3D/Combined7'];
C4dir = ['~/Dropbox/Adir/Research/Groups/BoneGroup/remodelling/Textons3D/Combined4'];

cd(FAdir)
curdir = dir;
[dirlen,w] = size(curdir);

for kd = 1:dirlen
    sname = curdir(kd,1).name;
    namelen = length(sname);
    
    if namelen > 2
        cd(FAdir)
        eval(['load ' sname])
        [r,c13] = size(thetamat);
        thetamatC13 = zeros(r,13);
        thetamatC7 = zeros(r,7);
        thetamatC4 = zeros(r,4);
        for kr = 1:r
            curv = thetamat(kr,:);
            v1 = curv(1:4);
            v2 = curv(5:8);
            v3 = curv(9:12);
            v13 = curv(13);
            mean1 = mean(v1);
            mean2 = mean(v2);
            mean3 = mean(v3);
            std1 = std(v1);
            std2 = std(v2);
            std3 = std(v3);
            thetamatC13(kr,:) = [sort(v1) sort(v2) sort(v3) v13];
            thetamatC7(kr,:) = [mean1 std1 mean2 std2 mean3 std3 v13];
            thetamatC4(kr,:) = [mean1 mean2 mean3 v13];
        end
        
        cd(C13dir)
        eval(['save ' sname ' thetamatC13'])
        cd(C7dir)
        eval(['save ' sname ' thetamatC7'])
        cd(C4dir)
        eval(['save ' sname ' thetamatC4'])
        
    end
end

cd(Hdir)