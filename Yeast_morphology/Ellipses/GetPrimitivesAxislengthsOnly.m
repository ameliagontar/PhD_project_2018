function GetPrimitivesAxislengthsOnly(r)

% 14 October 2016
%
% Takes the ellipses saved in Ellipse_fits and converts each ellipsoid 
% into a primitive E^p, where only the lengths of the ellipse axes are 
% recorded. Each E^p has length 2. r is the radius of the balls
% used to fit the ellipses, and is included as a parameter in the program
% so that changing directories is streamlined.
%
% Saves the new collection of primitives in the folder 
% Primitives_axislengths_only, with the filename Sample<_>_Timestep<_>.mat. 

sdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/Ellipse_fits';
tdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/Primitives_axislengths_only';
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology';
newdir = ['R',int2str(r)];

for s = 1:10
    for t = 1:8
        filename = ['Sample',int2str(s),'_Timestep',int2str(t),'.mat'];
        cd(sdir)
        cd(newdir)
        eval(['load ' filename])    % variable will have name ellipses
        [L,~] = size(ellipses);
        prims = zeros(L,2);
        k = 0;
        for l = 1:L
            ell = ellipses(l,:);
            l1 = 2*ell(7);
            l2 = 2*ell(8);
            primitive = [l1,l2];
            nantest = sum(isnan(primitive));
            inftest = sum(isinf(primitive));
            test = nantest+inftest;
            if test == 0
                k = k+1;
                prims(k,:) = primitive;
            end
        end
        prims = prims(1:k,:);
        cd(tdir)
        cd(newdir) 
        eval(['save ' filename ' prims'])
    end
end
cd(hdir)