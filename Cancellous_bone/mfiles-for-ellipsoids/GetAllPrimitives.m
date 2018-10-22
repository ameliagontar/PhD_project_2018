function off_proportions = GetAllPrimitives(R)

% 27 June 2016
%
% Computes primitives for all 90 sub-blocks.

sdir1 = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles-for-ellipsoids/Ellipsoid_fits';
sdir2 = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/RatData';
tdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles-for-ellipsoids/Primitives';
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles-for-ellipsoids';
newdir = ['R',int2str(R)];

off_proportions = zeros(90,1);
cd(sdir1)
cd(newdir)
curdir = dir;
L = length(curdir);
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
        [prims,off_cnt] = GetPrimitives_axislengths(ellipsoids,subblock);
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