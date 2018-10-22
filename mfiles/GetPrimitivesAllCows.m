function GetPrimitivesAllCows(N,d,s)

% 27 January 2017
%
% Computes a set of approximately N primitive vectors for all cows in the
% data set. d is the number of within-plane directions in which we are
% measuring thicknesses. s is the step size for making thickness
% measurements. 

sdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Marbling/Data';
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Marbling/mfiles';
tdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Marbling/mfiles/Primitives_OneBP';

cd(sdir)
curdir = dir;
L = length(curdir);
for l = 1:L
    filename = curdir(l).name;
    if length(filename) > 2
        cowcheck = filename(1:3);
        if strcmp('cow',cowcheck)
            eval(['load ' filename])
            cd(hdir)
            prims = GetPrimitivesOneCow(cow3D,N,d,s);
            cd(tdir)
            eval(['save ' filename ' prims'])
            cd(sdir)
        end
    end
end
cd(hdir)