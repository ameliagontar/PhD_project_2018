function textons = BS_GetTextons(group1,group2,t1,t2,no_dir,k)

% 14 December 2016
%
% A program written to compute textons for a two-group classification
% problem, with the images taken at one timestep for each group. This is a
% preliminary experiment to test how well our method can differentiate
% between strains (BS). The experiment may later be refined to include
% features from more than one timestep from each group, or use a different
% classifier (e.g. SVM, ODM), or a different method of evaluation of
% results (e.g. AUC to account for the uneven number of images in each
% class). 
%
% group1 and group2 are strings, giving the name of the strain. Choose from
% 'AWRI796_50um,' 'AWRI796_500um,' or 'AWRIR2_50um.' t1 and t2 are the
% timesteps that we want to use for group 1 and group 2 respectively. no_dir
% is the number of directions in which the thicknesses were measured for
% the oriented thickness textons. k is the number of clusters per class,
% i.e. should get 2k textons in total.

sdir1 = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/General-mfiles';
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/OTT_indices';

filename_sa_g1 = ['set_assignments_',group1,'.mat'];
filename_sa_g2 = ['set_assignments_',group2,'.mat'];
cd(sdir1)
eval(['load ' filename_sa_g1])
timepoint_assignments_g1 = set_assignments(:,t1);
eval(['load ' filename_sa_g2])
timepoint_assignments_g2 = set_assignments(:,t2);
cd(hdir)

% Get textons for group 1:
sdir2 = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/OTT_indices/Primitives_thickness_',group1,'/D',int2str(no_dir),'/NRI/t',int2str(t1)];
L1 = length(timepoint_assignments_g1);
no_training = ceil(L1/2);
all_primitives1 = [];
for i = 1:no_training
    s = timepoint_assignments_g1(i);
    sample = int2str(s);
    if length(sample) == 1
       filename_prims = ['sample0',sample];
    elseif length(sample) == 2
       filename_prims = ['sample',sample];
    else
       warning('Something went wrong!')
    end
    cd(sdir2)
    eval(['load ' filename_prims])
    all_primitives1 = [all_primitives1;prims];
    cd(hdir)
end
[~,textons_g1] = kmeans(all_primitives1,k);

% Get textons for group 2:
sdir3 = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/OTT_indices/Primitives_thickness_',group2,'/D',int2str(no_dir),'/NRI/t',int2str(t2)];
L2 = length(timepoint_assignments_g2);
no_training = ceil(L2/2);
all_primitives2 = [];
for i = 1:no_training
    s = timepoint_assignments_g2(i);
    sample = int2str(s);
    if length(sample) == 1
       filename_prims = ['sample0',sample];
    elseif length(sample) == 2
       filename_prims = ['sample',sample];
    else
       warning('Something went wrong!')
    end
    cd(sdir3)
    eval(['load ' filename_prims])
    all_primitives2 = [all_primitives2;prims];
    cd(hdir)
end
[~,textons_g2] = kmeans(all_primitives2,k);

% Combine textons:
textons = [textons_g1;textons_g2];
        
    