function textons = GetTextons(R,k)

% 28 June 2016
%
% For each of the 9 subgroups, loads the primitives for the training set
% and conducts k-means clustering on those primitives. Combines cluster
% centres from each of the 9 subgroups to form a texton dictionary of n=9k
% textons.
%
% R is the radius of the original ball drawn, and k is the number of
% clusters per class.

sdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles-for-ellipsoids/Primitives_only_axislengths';
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles-for-ellipsoids';
newdir = ['R',int2str(R)];

load 'Cohortmat.mat'    % variable has name Cohortmat
[NR,~] = size(Cohortmat);

cd(sdir)
cd(newdir)
% Find cluster centres for sham training block 1:
primitives_sham_b1 = [];
for nr = 1:NR
    idx = Cohortmat(nr,1);
    if idx < 10
        counter = ['0',int2str(idx)];
    elseif idx >= 10
        counter = int2str(idx);
    else
        warning('Something went wrong!')
    end
    filename = ['rat',counter,'w08b1.mat'];
    eval(['load ' filename])    % variable has name prims
    primitives_sham_b1 = [primitives_sham_b1;prims];
end
%disp('for sham block 1:')
[~,C_sham_b1] = kmeans(primitives_sham_b1,k);

% Find cluster centres for sham training block 2:
primitives_sham_b2 = [];
for nr = 1:NR
    idx = Cohortmat(nr,1);
    if idx < 10
        counter = ['0',int2str(idx)];
    elseif idx >= 10
        counter = int2str(idx);
    else
        warning('Something went wrong!')
    end
    filename = ['rat',counter,'w08b2.mat'];
    eval(['load ' filename])    % variable has name prims
    primitives_sham_b2 = [primitives_sham_b2;prims];
end
%disp('for sham block 2:')
[~,C_sham_b2] = kmeans(primitives_sham_b2,k);

% Find cluster centres for sham training block 3:
primitives_sham_b3 = [];
for nr = 1:NR
    idx = Cohortmat(nr,1);
    if idx < 10
        counter = ['0',int2str(idx)];
    elseif idx >= 10
        counter = int2str(idx);
    else
        warning('Something went wrong!')
    end
    filename = ['rat',counter,'w08b3.mat'];
    eval(['load ' filename])    % variable has name prims
    primitives_sham_b3 = [primitives_sham_b3;prims];
end
%disp('for sham block 3:')
[~,C_sham_b3] = kmeans(primitives_sham_b3,k);

% Find cluster centres for ovx training block 1:
primitives_ovx_b1 = [];
for nr = 1:NR
    idx = Cohortmat(nr,3);
    if idx < 10
        counter = ['0',int2str(idx)];
    elseif idx >= 10
        counter = int2str(idx);
    else
        warning('Something went wrong!')
    end
    filename = ['rat',counter,'w08b1.mat'];
    eval(['load ' filename])    % variable has name prims
    primitives_ovx_b1 = [primitives_ovx_b1;prims];
end
%disp('for ovx block 1:')
[~,C_ovx_b1] = kmeans(primitives_ovx_b1,k);

% Find cluster centres for ovx training block 2:
primitives_ovx_b2 = [];
for nr = 1:NR
    idx = Cohortmat(nr,3);
    if idx < 10
        counter = ['0',int2str(idx)];
    elseif idx >= 10
        counter = int2str(idx);
    else
        warning('Something went wrong!')
    end
    filename = ['rat',counter,'w08b2.mat'];
    eval(['load ' filename])    % variable has name prims
    primitives_ovx_b2 = [primitives_ovx_b2;prims];
end
%disp('for ovx block 2:')
[~,C_ovx_b2] = kmeans(primitives_ovx_b2,k);

% Find cluster centres for ovx training block 3:
primitives_ovx_b3 = [];
for nr = 1:NR
    idx = Cohortmat(nr,3);
    if idx < 10
        counter = ['0',int2str(idx)];
    elseif idx >= 10
        counter = int2str(idx);
    else
        warning('Something went wrong!')
    end
    filename = ['rat',counter,'w08b3.mat'];
    eval(['load ' filename])    % variable has name prims
    primitives_ovx_b3 = [primitives_ovx_b3;prims];
end
%disp('for ovx block 3:')
[~,C_ovx_b3] = kmeans(primitives_ovx_b3,k);

% Find cluster centres for ovx+zol training block 1:
primitives_oz_b1 = [];
for nr = 1:NR
    idx = Cohortmat(nr,5);
    if idx < 10
        counter = ['0',int2str(idx)];
    elseif idx >= 10
        counter = int2str(idx);
    else
        warning('Something went wrong!')
    end
    filename = ['rat',counter,'w08b1.mat'];
    eval(['load ' filename])    % variable has name prims
    primitives_oz_b1 = [primitives_oz_b1;prims];
end
%disp('for ovx+zol block 1:')
[~,C_oz_b1] = kmeans(primitives_oz_b1,k);

% Find cluster centres for ovx+zol training block 2:
primitives_oz_b2 = [];
for nr = 1:NR
    idx = Cohortmat(nr,5);
    if idx < 10
        counter = ['0',int2str(idx)];
    elseif idx >= 10
        counter = int2str(idx);
    else
        warning('Something went wrong!')
    end
    filename = ['rat',counter,'w08b2.mat'];
    eval(['load ' filename])    % variable has name prims
    primitives_oz_b2 = [primitives_oz_b2;prims];
end
%disp('for ovx+zol block 2:')
[~,C_oz_b2] = kmeans(primitives_oz_b2,k);

% Find cluster centres for ovx+zol training block 3:
primitives_oz_b3 = [];
for nr = 1:NR
    idx = Cohortmat(nr,5);
    if idx < 10
        counter = ['0',int2str(idx)];
    elseif idx >= 10
        counter = int2str(idx);
    else
        warning('Something went wrong!')
    end
    filename = ['rat',counter,'w08b3.mat'];
    eval(['load ' filename])    % variable has name prims
    primitives_oz_b3 = [primitives_oz_b3;prims];
end
%disp('for ovx+zol block 3:')
[~,C_oz_b3] = kmeans(primitives_oz_b3,k);

textons = [C_sham_b1;C_sham_b2;C_sham_b3;C_ovx_b1;C_ovx_b2;C_ovx_b3; ...
    C_oz_b1;C_oz_b2;C_oz_b3];
cd(hdir)



