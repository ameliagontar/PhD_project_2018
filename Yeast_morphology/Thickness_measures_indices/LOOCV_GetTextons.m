function [loaded_test,textons] = LOOCV_GetTextons(idx_array,LO,gvec,T,no_dir,k)

% 4 April 2017
%
% Computes textons for the training set in the LOOCV algorithm. idx_array
% is the indexing array computed using LOOCV_SortSets.m, LO is the sample
% number (out of the total number of samples) to be left out of the
% training set. gvec is a cell with one row and length equal to the number 
% of groups. Each entry in the cell is a string specifying the group name. 
% T is a vector of the same dimension as gvec, with each entry specifying 
% the timestep at which the image for that group should be taken. no_dir is
% the number of directions used to compute the oriented thickness textons, 
% and k is the number of clusters per class chosen during k-means 
% clustering.
%
% textons is an array of size Gk x no_dir, with each row representing a
% cluster centre (i.e. one texton). loaded_test is a list of images for
% which primitives were loaded as part of the training set, with column 1
% corresponding to the group number and column 2 corresponding to the
% sample number. This output is only acting as a check (to see whether the
% training set was correctly loaded) and may be suppressed later.

hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/OTT_indices';

no_groups = length(gvec);
textons = zeros(no_groups*k,no_dir);
group_LO = gvec{idx_array(LO,1)};
sample_LO = idx_array(LO,2);
loaded_test = [];
for G = 1:no_groups
    group_name = gvec{G};
    all_primitives = [];
    newdir = ['Shape_primitives_',group_name,'/D',int2str(no_dir),'/NRI/t',int2str(T(G))];
    cd(newdir)
    curdir = dir;
    L = length(curdir);
    for l = 1:L
        filename = curdir(l).name;
        if strcmp(filename(1),'s') 
            smp = filename(7:8);
            sample_check = str2double(smp);
            if ~(strcmp(group_name,group_LO) && sample_check == sample_LO)
                eval(['load ' filename])
                all_primitives = [all_primitives;prims];
                loaded = [G,sample_check];
                loaded_test = [loaded_test;loaded];
            end
        end
    end
    cd(hdir)
    [~,textons_group] = kmeans(all_primitives,k);
    textons((G-1)*k+1:G*k,:) = textons_group;
end
    