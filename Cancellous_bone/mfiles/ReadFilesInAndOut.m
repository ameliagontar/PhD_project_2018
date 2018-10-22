function ReadFilesInAndOut

% July 28 2014 (Rostock)
%
% This is an example of reading in files from directories and writing files
% to directories. Names of output files are constructed.
% 
% hdir is the home directory - the directory containing this program
% sdir is the source directory - the directory with files to be read
% tdir is the target directory - the directory where new files are stored

sdir = ['~/Dropbox/Adir/Research/Groups/BoneGroup/remodelling/RatData400/BreeRatData'];
tdir = ['~/Dropbox/Adir/Research/Groups/BoneGroup/remodelling/Textons3D/FeatureArrays'];
hdir = ['~/Dropbox/Adir/Research/Groups/BoneGroup/remodelling/Textons3D/mfiles'];

cd(sdir)
curdir = dir;
[dirlen,w] = size(curdir);
for kd = 1:dirlen
    sname = curdir(kd,1).name;
    namelen = length(sname);
    if namelen > 2
        eval(['load ' sname])
        disp(sname)
        sumx = sum(sum(sum(x)));
        tname =[sname(1:8) 'new' int2str(kd)];
        disp(tname)
        cd(tdir)
        eval(['save ' tname ' sumx'])
        cd(sdir)
    end
end
    
cd(hdir)

