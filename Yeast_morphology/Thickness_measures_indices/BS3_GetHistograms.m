function [text_occ_tr,class_labels_tr,text_occ_te,class_labels_te] = BS3_GetHistograms(gvec,T,textons,no_dir,RIflag)

% 15 December 2016
%
% Computes histograms of texton occurrences for all images in the data
% sets, for when we want to classify between two or more strains (BS3). 

% gvec is a cell with one row and length equal to the number of groups. 
% Each entry in the cell is a string specifying the group name. T is a 
% vector of the same dimension as gvec, with each entry specifying the 
% timestep at which the image for that group should be taken. no_dir is the
% number of directions used to compute the oriented thickness textons, and 
% k is the number of clusters per class chosen during k-means clustering.
% The three spatial indices are appended to the feature vectors.
%
% To classify all three groups at time closest to 170 hours, use:
% gvec = {'AWRI796_50um','AWRI796_500um','AWRIR2_50um'}; T = [6,7,7].
%
% EDIT 31 March 2017: RIflag is the rotation invariance flag. RIflag = 0 if
% rotation invariance is off and RIflag = 1 if rotation invariance is on.

sdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/General-mfiles';
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/OTT_indices';

if ~(sum(size(gvec) == size(T)) == 2)
    warning('Dimensions of group names and timesteps do not match!')
end

[~,no_groups] = size(gvec);
[n,~] = size(textons);
text_occ_tr = [];
class_labels_tr = [];
text_occ_te = [];
class_labels_te =[];
for G = 1:no_groups
    filename_sa = ['set_assignments_',gvec{G},'.mat'];
    cd(sdir)
    eval(['load ' filename_sa])
    cd(hdir)
    timestep_assignments = set_assignments(:,T(G));
    L = length(timestep_assignments);
    no_training = ceil(L/2);
    no_testing = L-no_training;
    text_occ_tr_group = zeros(no_training,n+3);
    class_labels_tr_group = G*ones(no_training,1);
    text_occ_te_group = zeros(no_testing,n+3);
    class_labels_te_group = G*ones(no_testing,1);
    filename_radial = ['I_r_',gvec{G},'.mat'];
    filename_angular = ['I_angular_',gvec{G},'.mat'];
    filename_pair = ['I_Theta_',gvec{G},'.mat'];
    cd('Index_arrays')
    I_r = importdata(filename_radial);
    I_angular = importdata(filename_angular);
    I_Theta = importdata(filename_pair);
    cd(hdir)
    if RIflag == 0
        newdir = ['Shape_primitives_',gvec{G},'/D',int2str(no_dir),'/NRI/t',int2str(T(G))];
    elseif RIflag == 1
        newdir = ['Shape_primitives_',gvec{G},'/D',int2str(no_dir),'/RI/t',int2str(T(G))];
    end
    for idx = 1:no_training
        s = timestep_assignments(idx);
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
        cd(hdir)
        text_occ = GetTextonMap(prims,textons);
        metric1 = I_r(T(G),s)/n;
        metric2 = I_angular(T(G),s)/n;
        metric3 = I_Theta(T(G),s)/n;
        text_occ_tr_group(idx,:) = [text_occ,metric1,metric2,metric3];
    end
    for idx = 1:no_testing
        s = timestep_assignments(no_training+idx);
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
        cd(hdir)
        text_occ = GetTextonMap(prims,textons);
        metric1 = I_r(T(G),s)/n;
        metric2 = I_angular(T(G),s)/n;
        metric3 = I_Theta(T(G),s)/n;
        text_occ_te_group(idx,:) = [text_occ,metric1,metric2,metric3];
    end
    text_occ_tr = [text_occ_tr;text_occ_tr_group];
    class_labels_tr = [class_labels_tr;class_labels_tr_group];
    text_occ_te = [text_occ_te;text_occ_te_group];
    class_labels_te = [class_labels_te;class_labels_te_group];
end