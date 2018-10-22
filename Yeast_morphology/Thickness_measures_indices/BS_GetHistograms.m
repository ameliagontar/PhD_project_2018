function [text_occ_g1_tr,text_occ_g2_tr,text_occ_g1_te,text_occ_g2_te] = BS_GetHistograms(group1,group2,t1,t2,textons,no_dir)

% 14 December 2016
%
% A program that computes histograms of texton occurrences (feature
% vectors) for a two-group classification problem. 
%
% group1 and group2 are strings, giving the name of the strain. Choose from
% 'AWRI796_50um,' 'AWRI796_500um,' or 'AWRIR2_50um.' t1 and t2 are the
% timesteps that we want to use for group 1 and group 2 respectively.
% textons is the array of textons computed previously, where each cluster
% centre corresponds to one row. no_dir is the number of dirctions used
% whule computing the oriented thickness textons. 

sdir1 = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/General-mfiles';
sdir2 = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/OTT_indices/Primitives_thickness_',group1,'/D',int2str(no_dir),'/NRI/t',int2str(t1)];
sdir3 = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/OTT_indices/Primitives_thickness_',group2,'/D',int2str(no_dir),'/NRI/t',int2str(t2)];
sdir4 = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/OTT_indices/Index_arrays';
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/OTT_indices';

% Load training and testing set assignments:
filename_sa_g1 = ['set_assignments_',group1,'.mat'];
filename_sa_g2 = ['set_assignments_',group2,'.mat'];
cd(sdir1)
eval(['load ' filename_sa_g1])
timepoint_assignments_g1 = set_assignments(:,t1);
eval(['load ' filename_sa_g2])
timepoint_assignments_g2 = set_assignments(:,t2);
cd(hdir)

% Set up arrays of texton occurrences:
L1 = length(timepoint_assignments_g1);
no_training_g1 = ceil(L1/2);
no_testing_g1 = L1-no_training_g1;
L2 = length(timepoint_assignments_g2);
no_training_g2 = ceil(L2/2);
no_testing_g2 = L2-no_training_g2;
[n,~] = size(textons);
text_occ_g1_tr = zeros(no_training_g1,n+3);
text_occ_g2_tr = zeros(no_training_g2,n+3);
text_occ_g1_te = zeros(no_testing_g1,n+3);
text_occ_g2_te = zeros(no_testing_g2,n+3);

% Load arrays of spatial index values:
filename_radial_g1 = ['I_r_',group1,'.mat'];
filename_angular_g1 = ['I_angular_',group1,'.mat'];
filename_pair_g1 = ['I_Theta_',group1,'.mat'];
filename_radial_g2 = ['I_r_',group2,'.mat'];
filename_angular_g2 = ['I_angular_',group2,'.mat'];
filename_pair_g2 = ['I_Theta_',group2,'.mat'];
cd(sdir4)
I_r_g1 = importdata(filename_radial_g1);
I_angular_g1 = importdata(filename_angular_g1);
I_Theta_g1 = importdata(filename_pair_g1);
I_r_g2 = importdata(filename_radial_g2);
I_angular_g2 = importdata(filename_angular_g2);
I_Theta_g2 = importdata(filename_pair_g2);
cd(hdir)

% Get histograms for group 1:
% Training:
for i = 1:no_training_g1
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
    cd(hdir)
    text_occ = GetTextonMap(prims,textons);
    metric1 = I_r_g1(t1,s)/n;
    metric2 = I_angular_g1(t1,s)/n;
    metric3 = I_Theta_g1(t1,s)/n;
    text_occ_g1_tr(i,:) = [text_occ,metric1,metric2,metric3];
end
% Testing:
for i = 1:no_testing_g1
    s = timepoint_assignments_g1(no_training_g1+i);
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
    cd(hdir)
    text_occ = GetTextonMap(prims,textons);
    metric1 = I_r_g1(t1,s)/n;
    metric2 = I_angular_g1(t1,s)/n;
    metric3 = I_Theta_g1(t1,s)/n;
    text_occ_g1_te(i,:) = [text_occ,metric1,metric2,metric3];
end

% Get histograms for group 2:
% Training:
for i = 1:no_training_g2
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
    cd(hdir)
    text_occ = GetTextonMap(prims,textons);
    metric1 = I_r_g2(t2,s)/n;
    metric2 = I_angular_g2(t2,s)/n;
    metric3 = I_Theta_g2(t2,s)/n;
    text_occ_g2_tr(i,:) = [text_occ,metric1,metric2,metric3];
end
% Testing:
for i = 1:no_testing_g2
    s = timepoint_assignments_g2(no_training_g2+i);
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
    cd(hdir)
    text_occ = GetTextonMap(prims,textons);
    metric1 = I_r_g2(t2,s)/n;
    metric2 = I_angular_g2(t2,s)/n;
    metric3 = I_Theta_g2(t2,s)/n;
    text_occ_g2_te(i,:) = [text_occ,metric1,metric2,metric3];
end



    
