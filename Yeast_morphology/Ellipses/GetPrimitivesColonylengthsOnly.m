function GetPrimitivesColonylengthsOnly(r,stepsize)

% 14 October 2016
%
% Takes the ellipses saved in Ellipse_fits and converts each ellipsoid 
% into a primitive E^p, where only the lengths of the colony are recorded,
% in the direction of the major and minor axes of the ellipse. Each E^p has
% length 2. r is the radius of the balls used to fit the ellipses, and is 
% included as a parameter in the program so that changing directories is 
% streamlined. stepsize is the step size used to make the thickness 
% measurements.
%
% Saves the new collection of primitives in the folder 
% Primitives_colonylengths_only, with the filename Sample<_>_Timestep<_>.mat. 

sdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/Ellipse_fits';
tdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/Primitives_colonylengths_only';
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology';
newdir = ['R',int2str(r)];

load 'rawdata.mat'
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
        prims = zeros(L,2);
        m = 0;
        for l = 1:L
            ell = ellipses(l,:);
            [L1,L2] = GetThicknessForEllipses(im,ell,stepsize);
            if ~(L1 == 0 && L2 == 0)
                m = m+1;
                primitive = [L1,L2];
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
    end
end
cd(hdir)