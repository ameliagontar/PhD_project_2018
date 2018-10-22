function [best_acc,best_fts_tie,no_ties] = LOOCV_LeaveOneOut(idx_array,LO,gvec,T,no_dir,k,no_features)

% 4 April 2017
%
% Classifies one image, labelled number LO (this is the image that has been
% left out of the training set). Trains the classifier by computing textons
% on the training set and using frequency of texton occurrences as the
% features in LDA. best_acc is the accuracy of classification for that one
% image (0 or 1), and best_fts is the feature or features used to make that
% classification.

[~,textons] = LOOCV_GetTextons(idx_array,LO,gvec,T,no_dir,k);
[class_labels_tr,class_labels_te,text_occ_tr,text_occ_te] = LOOCV_GetHistograms(idx_array,LO,gvec,T,textons,no_dir);
[~,best_acc,best_fts_tie,no_ties] = GetBestClassifier(no_features,text_occ_tr,class_labels_tr,text_occ_te,class_labels_te);