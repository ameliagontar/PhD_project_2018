function textons = BS3_GetTextons(gvec,T,no_dir,k,RIflag)

% 15 December 2016
%
% A program that will classify all three groups of yeast colonies by strain
% (BS3). It is written generally, allowing any number of groups and could
% be used for more than three groups if more data becomes available. gvec
% is a cell with one row and length equal to the number of groups. Each
% entry in the cell is a string specifying the group name. T is a vector of
% the same dimension as gvec, with each entry specifying the timestep at
% which the image for that group should be taken. no_dir is the number of 
% directions used to compute the oriented thickness textons, and k is the 
% number of clusters per class chosen during k-means clustering.
%
% To classify all three groups at time closest to 170 hours, use:
% gvec = {'AWRI796_50um','AWRI796_500um','AWRIR2_50um'}; T = [6,7,7].
%
% EDIT 31 March 2017: RIflag is the rotation invariance flag. RIflag = 0 if
% ratation invariance is off and RIflag = 1 if rotation invariance is on.

sdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/General-mfiles';
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/OTT_indices';

if ~(sum(size(gvec) == size(T)) == 2)
    warning('Dimensions of group names and timesteps do not match!')
end

[~,no_groups] = size(gvec);
textons = zeros(no_groups*k,no_dir);
for G = 1:no_groups
    filename_sa = ['set_assignments_',gvec{G},'.mat'];
    cd(sdir)
    eval(['load ' filename_sa])
    cd(hdir)
    all_primitives = [];
    timepoint_assignments = set_assignments(:,T(G));
    L = length(timepoint_assignments);
    no_training = ceil(L/2);
    if RIflag == 0
        newdir = ['Shape_primitives_',gvec{G},'/D',int2str(no_dir),'/NRI/t',int2str(T(G))];
    elseif RIflag == 1
        newdir = ['Shape_primitives_',gvec{G},'/D',int2str(no_dir),'/RI/t',int2str(T(G))];
    end
    for idx = 1:no_training
        s = timepoint_assignments(idx);
        sample = int2str(s);
        if length(sample) == 1
           filename_prims = ['sample0',sample];
        elseif length(sample) == 2
           filename_prims = ['sample',sample];
        else
           warning('Something went wrong!')
        end
        cd(newdir)
        eval(['load ' filename_prims])
        all_primitives = [all_primitives;prims];
        cd(hdir)
    end
    [~,textons_group] = kmeans(all_primitives,k);
    textons((G-1)*k+1:G*k,:) = textons_group;
end