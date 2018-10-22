function GetAllPrimitives_new_axislengths(R)

% 18 July 2016
%
% Computes primitives for all 90 sub-blocks. Here, the primitives E^p have
% the form (u_1,u_2,u_3,v_1,v_2,w_1), with each of the vectors scaled by
% the length of the major, middle and minor axes, respectively. Note the
% lengths are the lengths of the axes, NOT the semi-axes. Saves the array
% of primitives for each sub-block. R is the radius of the balls originally
% used to fit the ellipsoids. 

sdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles-for-ellipsoids/Ellipsoid_fits';
tdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles-for-ellipsoids/Primitives_new_axislengths';
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles-for-ellipsoids';
newdir = ['R',int2str(R)];

cd(sdir)
cd(newdir)
curdir = dir;
L = length(curdir);
k = 0;
for l = 1:L
    filename = curdir(l).name;
    if length(filename) > 9
        k = k+1;
        eval(['load ' filename])    % will have variable name ellipsoids
        cd(hdir)
        prims = GetPrimitives_new_axislengths(ellipsoids);
        cd(tdir)
        cd(newdir)
        eval(['save ' filename ' prims'])
        cd(sdir)
        cd(newdir)
    end
end
cd(hdir)