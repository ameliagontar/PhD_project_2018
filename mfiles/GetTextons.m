function textons = GetTextons(k)

% 27 February 2017
%
% Computes textons by loading and clustering all primitive vectors. This
% experiment may be modified later to incorporate training and testing, but
% for now all images/steaks are treated as 'training'. The model will later
% be evaluated using correlation. k is the total number of clusters.

sdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Marbling/mfiles/Primitives_OneBP';
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Marbling/mfiles';

cd(sdir)
curdir = dir;
L = length(curdir);
primitives = [];
for l = 1:L
    filename = curdir(l).name;
    if length(filename) > 2
        cowcheck = filename(1:3);
        if strcmp('cow',cowcheck)
            eval(['load ' filename])
            primitives = [primitives;prims];
        end
    end
end
cd(hdir)

[~,textons] = kmeans(primitives,k);
    
        