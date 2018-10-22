function AllRats13FeaturesSkel

% 22 April 2015
%
% Adaptation of Murk's code to compute the feature arrays for the
% skeletonised rat blocks, instead of the original rat blocks.
%
% This program uses the program ThicknessFeatures4or13.m to compute the
% local thickness at 13 orientations for all 30 rats at week 0 and at
% week 8. Output files are of size N x 13, where N is the number of voxels
% used to do the computations. The entry in row r column c is the thickness
% in direction theta_c at voxel r. Output files are stored in the directory
% FeatureArrays.

tic
sdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/RatData-skel'];
tdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/my-FeatureArrays'];
hdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/my-mfiles'];

w08 = int2str(8);   % select blocks from week 8
avec = [1 101 201]; % the initial slices for the three blocks
L = 99;             % the number of slices per sub-block is L + 1
M = 13;             % parameter of the program ThicknessFeatures4or13.m
maxk = 200;         % maximum length of line segments considered is 2*maxk+1

cd(sdir)
curdir = dir;
[dirlen,w] = size(curdir);

for kd = 1:dirlen
    sname = curdir(kd,1).name;
    namelen = length(sname);
    
    if namelen > 2
        c8 = sname(8);
        
        if isequal(w08,c8) == 1
            eval(['load ' sname])
            
            for kb = 1:3
                a = avec(kb);
                
                % The current 3D data block is called skel
                % The sub-block extracted is called curB
                curB = skel(:,:,a:a+L);      
                Nvox = sum(sum(sum(curB)));
                
                % set the name of the output file
                bname = [sname(1:12) 'B' int2str(kb)];
                
                % Based on the number of on voxels in the sub-block curB,
                % the factor for subsampling must be determined. The target
                % for each sub-block is to record thickness at 10,000
                % voxels but some sub-block do not have this many on
                % voxels.
                if Nvox < 10000
                    ssf = 1;
                    disp('fewer than 10000 on voxels in')
                    disp(bname)
                else
                    ssf = 10000/Nvox;
                end
                
                % Run the thickness feature program.
                cd(hdir)
                thetamat = ThicknessFeatures4or13Skel(curB,maxk,M,ssf);
                
                % Set the path to the output (target) directory, write the
                % file thetamat to this directory and reset the path the
                % source directory.
                
                cd(tdir)
                eval(['save ' bname ' thetamat'])
                cd(sdir)
                
            end
        end
    end
end
    
cd(hdir)

toc
