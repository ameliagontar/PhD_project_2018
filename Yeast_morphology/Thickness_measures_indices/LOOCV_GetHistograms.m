function [class_labels_tr,class_labels_te,text_occ_tr,text_occ_te] = LOOCV_GetHistograms(idx_array,LO,gvec,T,textons,no_dir)

% 4 April 2017
%
% Computes class labels and histograms of texton occurrences for all images
% in the data set, and then separates them into training and testing based
% on the one sample (sample number LO) that is meant to be left out. 
% idx_array is the indexing array computed using LOOCV_SortSets.m. gvec is 
% a cell with one row and length equal to the number of groups. Each entry 
% in the cell is a string specifying the group name. T is a vector of the 
% same dimension as gvec, with each entry specifying the timestep at which 
% the image for that group should be taken. no_dir is the number of 
% directions used to compute the textons.
%
% The histograms of texton occurrences include the spatial indices, with
% the radial index listed in the (n+1)th slot, the angular index listed in 
% the (n+2)th slot, and the angular pair-correlation index listed in the
% (n+3)th slot, where n = Gk is the number of textons.

hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/OTT_indices';

[total_samples,~] = size(idx_array);
[n,~] = size(textons);
class_labels_all = idx_array(:,1);
text_occ_all = zeros(total_samples,n+3);
for S = 1:total_samples
    G = idx_array(S,1);
    sample_no = idx_array(S,2);
    group_name = gvec{G};
    newdir = ['Shape_primitives_',group_name,'/D',int2str(no_dir),'/NRI/t',int2str(T(G))];
    sample = int2str(sample_no);
    if length(sample) == 1
       filename_prims = ['sample0',sample];
    elseif length(sample) == 2
       filename_prims = ['sample',sample];
    else
       warning('Something went wrong!')
    end
    cd(newdir)
    eval(['load ' filename_prims])
    cd(hdir)
    text_occ = GetTextonMap(prims,textons);
    filename_radial = ['I_r_',group_name,'.mat'];
    filename_angular = ['I_angular_',group_name,'.mat'];
    filename_pair = ['I_Theta_',group_name,'.mat'];
    cd('Index_arrays')
    I_r = importdata(filename_radial);
    I_angular = importdata(filename_angular);
    I_Theta = importdata(filename_pair);
    cd(hdir)
    metric1 = I_r(T(G),sample_no)/n;
    metric2 = I_angular(T(G),sample_no)/n;
    metric3 = I_Theta(T(G),sample_no)/n;
    text_occ_all(S,:) = [text_occ,metric1,metric2,metric3];
end

% Separate into training and testing based on the sample to be left out:
class_labels_te = class_labels_all(LO,:);
class_labels_all(LO,:) = [];
class_labels_tr = class_labels_all;
text_occ_te = text_occ_all(LO,:);
text_occ_all(LO,:) = [];
text_occ_tr = text_occ_all;
