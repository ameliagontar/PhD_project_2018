function off_proportions = GetAllPrimitives_only_bonelengths(R,stepsize)

% 24 August 2016
%
% Computes primitives for all 90 sub-blocks. Here, the primitives E^p have
% the form (L_1,L_2,L_3), where the L's are the lengths of the bone segment
% in the major, middle and minor directions. R is the radius of the balls 
% originally used to fit the ellipsoids. stepsize is the size of the steps 
% used to calculate the bone length, during subsampling.
%
% off_proportions is the vector of proportions for each of the 90
% sub-blocks, for which the ellipsoid centroids fall outside the bone. 

sdir1 = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles-for-ellipsoids/Ellipsoid_fits';
sdir2 = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/RatData';
tdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles-for-ellipsoids/Primitives_only_bonelengths';
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles-for-ellipsoids';
newdir = ['R',int2str(R)];

cd(sdir1)
cd(newdir)
curdir = dir;
L = length(curdir);
off_proportions = zeros(L,1);
k = 0;
for l = 1:L
    filename = curdir(l).name;
    if length(filename) > 9
        k = k+1;
        eval(['load ' filename])    % will have variable name ellipsoids
        [N,~] = size(ellipsoids);
        ratblockname = [filename(1:8),'.mat'];
        cd(sdir2)
        eval(['load ' ratblockname])    % will have variable name x
        cd(hdir)
        if filename(10) == '1'
            subblock = x(:,:,1:100);
        elseif filename(10) == '2'
            subblock = x(:,:,101:200);
        elseif filename(10) == '3'
            subblock = x(:,:,201:300);
        else
            warning('Something went wrong!')
        end
        [prims,off_cnt] = GetPrimitives_only_bonelengths(ellipsoids,subblock,stepsize);
        % Remove the rows of prims that contain all zeros, i.e. where the
        % centroid of the ellipsoid falls outside the bone. There are
        % different ways of dealing with this, but one option is to simply
        % disregard these ellipsoids... maybe to show that this method
        % isn't ideal?
        S = sum(prims,2);
        F = find(~S);
        prims(F,:) = [];
        off_prop = off_cnt/N;
        off_proportions(k) = off_prop;
        cd(tdir)
        cd(newdir)
        eval(['save ' filename ' prims'])
        cd(sdir1)
        cd(newdir)
    end
end
off_proportions = off_proportions(1:k);
cd(hdir)