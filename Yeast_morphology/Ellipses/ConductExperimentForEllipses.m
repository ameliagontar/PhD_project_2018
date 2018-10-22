function [best_acc_vec,best_fts_vec] = ConductExperimentForEllipses(r,k,no_features,trials)

% 8 September 2016
%
% Conducts a full classification experiment on the yeast colony data, with
% no_features features, k clusters per class, and using the primitives
% derived from ellipses fit to the data. Due to the small nature of the
% data set, the classifier is trained on a training set and tested on a
% testing set of images and there is no cross validation step. The accuracy
% scores are on 40 images in the testing set. The textons are re-computed
% for each trial and this is the stochastic step.
%
% This program is based on ConductExperiment.m, and calls some new programs
% and some general programs written previously (for the experiment where
% the primitives were obtained using thickness measures). r is the radius
% of the balls used to draw the ellipses, and trials is the number of 
% trials. 

tdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/Results_temporary';
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology';

best_acc_vec = zeros(trials,1);
best_fts_vec = zeros(trials,no_features);
for m = 1:trials
    disp(['Now conducting trial ' int2str(m)])
    textons = GetTextonsForEllipses(r,k);
    [text_occ_tr,class_labels_tr,text_occ_te,class_labels_te] = GetHistogramsForEllipses(r,textons);
    [best_acc,best_fts] = GetBestClassifier(no_features,text_occ_tr,class_labels_tr,text_occ_te,class_labels_te);
    best_acc_vec(m) = best_acc;
    best_fts_vec(m,:) = best_fts;
    cd(tdir)
    save('best_acc_vec.mat','best_acc_vec')
    cd(hdir)
end