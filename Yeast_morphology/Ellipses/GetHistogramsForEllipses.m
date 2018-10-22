function [text_occ_tr,class_labels_tr,text_occ_te,class_labels_te] = GetHistogramsForEllipses(r,textons)

% 8 September 2016
%
% For each yeast colony image, finds the (normalised) histogram of texton
% occurrences, and separates this into the training and testing sets. r is
% the radius of the balls used to fit the ellipses, and textons is the set
% of textons, with 8k rows.
%
% text_occ_tr is the array of texton occurrences for the training set of
% images, of size 40 x 8k. Each row represents one histogram for one image.
% class_labels_tr is the array of class labels, each given by a numerical
% value corresponding to the timestep, of length 40. The corresponding
% arrays labelled '_te' correspond to the testing set of images.

sdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/Primitives_colonylengths_only';
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology';
newdir = ['R',int2str(r)];

% Load set assignments and compute histograms:
load 'set_assignments.mat'
[n,~] = size(textons);
text_occ_tr = zeros(40,n);
text_occ_te = zeros(40,n);
class_labels_tr = zeros(40,1);
class_labels_te = zeros(40,1);

for t = 1:8
    text_occ_tr_t = zeros(5,n);
    class_labels_tr_t = t*ones(5,1);
    text_occ_te_t = zeros(5,n);
    class_labels_te_t = t*ones(5,1);
    assgns = set_assignments(:,t);
    for idx = 1:5
        s = assgns(idx);
        filename = ['Sample',int2str(s),'_Timestep',int2str(t)];
        cd(sdir)
        cd(newdir)
        eval(['load ' filename])
        cd(hdir)
        text_occ = GetTextonMap(prims,textons);
        text_occ_tr_t(idx,:) = text_occ;
    end
    for idx = 6:10
        s = assgns(idx);
        filename = ['Sample',int2str(s),'_Timestep',int2str(t)];
        cd(sdir)
        cd(newdir)
        eval(['load ' filename])
        cd(hdir)
        text_occ = GetTextonMap(prims,textons);
        text_occ_te_t(idx-5,:) = text_occ;
    end
    text_occ_tr(5*(t-1)+1:5*t,:) = text_occ_tr_t;
    text_occ_te(5*(t-1)+1:5*t,:) = text_occ_te_t;
    class_labels_tr(5*(t-1)+1:5*t,:) = class_labels_tr_t;
    class_labels_te(5*(t-1)+1:5*t,:) = class_labels_te_t;
end