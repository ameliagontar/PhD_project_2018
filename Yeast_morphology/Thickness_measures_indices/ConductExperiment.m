function [best_acc_vec,best_fts_vec] = ConductExperiment(no_dir,k,no_features,trials,RIflag,Rflag,Nflag)

% 9 August 2016
%
% Conducts an entire classification experiment on the yeast morphology 
% data, assuming that "pattern primitives" have already been calculated for
% each image. k is the number of textons per class, no_features is the
% number of features used for classification, and trials is the number of 
% trials. The textons are re-computed for each trial, and there is no cross
% validation step due to the small number of images in the data set. 
%
% EDIT 12 August 2016: The program was edited so that the appropriate
% directory is accessed automatically. no_dir is the number of directions
% used to compute the thicknesses, RIflag is the rotation invariance flag.
% RIflag = 1 if rotation invariance is on, RIflag = 0 if rotation
% invariance if off. Rflag = 1 for random experiment. Rflag = 0 if
% randomness off.
%
% EDIT 31 October 2016: Currently edited so that the spatial indices from
% Binder 2015 are included in the feature vectors for classification. 
% Feature number 81 corresponds to the radial index, feature 82 corresponds
% to the angular index, and feature 83 corresponds to the pair-correlation
% index.
%
% EDIT 2 November 2016: Edited so that we can run and save the results for
% more than one value of no_dir at a time.
%
% EDIt 21 November: removed the variable poss and inserted the variable 
% Nflag. Nflag = 1 if the textons are to be normalised as in the Pattern
% Recognition paper, Nflag = 0 if the default implementation of textons is
% to be used. Dflag is the density flag. Dflag = 1 if the density feature 
% is to be appended to the end of each feature vector, Dflag = 0 if only 
% the texton occurrences are to be used as features.

tdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/Results_temporary';
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology';

best_acc_vec = zeros(trials,1);
best_fts_vec = zeros(trials,no_features);
filename_best_acc = ['best_acc_vec_D',int2str(no_dir),'.mat'];
filename_best_fts = ['best_fts_vec_D',int2str(no_dir),'.mat'];
for m = 1:trials
    disp(['Now conducting trial ' int2str(m)])
    if Rflag == 1
        PermuteLabels(no_dir);
    end
    textons = GetTextons(no_dir,k,RIflag,Rflag,Nflag);
    [text_occ_tr,class_labels_tr,text_occ_te,class_labels_te] = GetHistograms(no_dir,textons,RIflag,Rflag,Nflag,Dflag);
    [best_acc,best_fts] = GetBestClassifier(no_features,text_occ_tr,class_labels_tr,text_occ_te,class_labels_te);
    best_acc_vec(m) = best_acc;
    best_fts_vec(m,:) = best_fts;
    cd(tdir)
    eval(['save ' filename_best_acc ' best_acc_vec'])
    eval(['save ' filename_best_fts ' best_fts_vec'])
    %save('best_acc_vec.mat','best_acc_vec')
    %save('best_fts_vec.mat','best_fts_vec')
    cd(hdir)
end