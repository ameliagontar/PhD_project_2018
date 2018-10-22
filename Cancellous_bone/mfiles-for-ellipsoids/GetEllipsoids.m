function GetEllipsoids(N,radius)

% 16 May 2016
%
% For each rat at week 8, computes the three sub-blocks. Then, for each
% sub-block, fits N ellipsoids with radius 'radius.' For each sub-block, 
% saves the list of ellipsoids, for use later as structural primitives.
% Should be about 10000 rows in each list, with a total of 90 sub-blocks 
% (30 rats multiplied by 3 sub-blocks for each).

sdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/RatData';
tdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles-for-ellipsoids/Ellipsoid_fits';
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles-for-ellipsoids';

newdir = ['R',int2str(radius)];
cd(sdir)
curdir = dir;
L = length(curdir);
for l = 1:L
    filename = curdir(l).name;
    filelength = length(filename);
    if filelength > 9
        wk = filename(7:8);
        checkweek = sum(wk=='08');
        if checkweek == 2
            load(filename)   % variable will have name x
            b1 = x(:,:,1:100);
            b2 = x(:,:,101:200);
            b3 = x(:,:,201:300);
            cd(hdir)
            ellipsoids = Ellipsoid_subsample(b1,N,radius);
            newname = [filename(1:8),'b1.mat'];
            cd(tdir)
            cd(newdir)
            eval(['save ' newname ' ellipsoids'])
            cd(hdir) 
            ellipsoids = Ellipsoid_subsample(b2,N,radius);
            newname = [filename(1:8),'b2.mat'];
            cd(tdir)
            cd(newdir)
            eval(['save ' newname ' ellipsoids'])
            cd(hdir) 
            ellipsoids = Ellipsoid_subsample(b3,N,radius);
            newname = [filename(1:8),'b3.mat'];
            cd(tdir)
            cd(newdir)
            eval(['save ' newname ' ellipsoids'])
            cd(sdir)
        end
    end
end
cd(hdir)