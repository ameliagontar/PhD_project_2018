function [total_no_ellipses,off_no] = GetPrimitivesColonylengths(r,stepsize)

% 7 September 2016
%
% Takes the ellipses saved in Ellipse_fits and converts each ellipsoid 
% into a primitive E^p, where each of the unit direction vectors is scaled
% by the thickness of the colony in that direction. Redundancies in the 
% representation have been removed. Each E^p has length 3. r is the radius 
% of the balls used to fit the ellipses, and is included as a parameter in 
% the program so that changing directories is streamlined. stepsize is the
% step size used to make the thickness measurements.
%
% Saves the new collection of primitives in the folder 
% Primitives_colonylengths, with the filename Sample<_>_Timestep<_>.mat. 

sdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/Ellipse_fits';
tdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/Primitives_colonylengths';
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology';
newdir = ['R',int2str(r)];

load 'rawdata.mat'
total_no_ellipses = zeros(80,1);
off_no = zeros(80,1);
k = 0;
for s = 1:10
    for t = 1:8
        k = k+1;
        im = rawdata(:,:,t,s);
        filename = ['Sample',int2str(s),'_Timestep',int2str(t),'.mat'];
        cd(sdir)
        cd(newdir)
        eval(['load ' filename])    % variable will have name ellipses
        cd(hdir)
        [L,~] = size(ellipses);
        total_no_ellipses(k) = L;
        prims = zeros(L,3);
        m = 0;
        for l = 1:L
            ell = ellipses(l,:);
            u11 = ell(3);
            u12 = ell(4);
            u21 = ell(5);
            [L1,L2] = GetThicknessForEllipses(im,ell,stepsize);
            if ~(L1 == 0 && L2 == 0)
                m = m+1;
                primitive = [L1*u11,L1*u12,L2*u21];
                prims(m,:) = primitive;
            end
        end
        prims = prims(1:m,:);
        if t == 1 || t == 2
            prims = (2/5)*prims;
        end
        cd(tdir)
        cd(newdir) 
        eval(['save ' filename ' prims'])
        off_no(k) = L-m;
    end
end
cd(hdir)