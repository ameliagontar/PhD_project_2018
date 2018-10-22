function [best_acc_vec,best_fts,no_ties_vec] = BS3_ConductTrials(gvec,T,no_dir,k,no_features,no_trials,RIflag)

% 15 December 2016
%
% A program that conducts no_trials trials of a classification experiment
% for two or more strains of the yeast colonies.

best_acc_vec = zeros(no_trials,1);
best_fts = cell(no_trials,1);
no_ties_vec = zeros(no_trials,1);
for t = 1:no_trials
    disp(['Now conducting trial ',int2str(t)])
    textons = BS3_GetTextons(gvec,T,no_dir,k,RIflag);
    [text_occ_tr,class_labels_tr,text_occ_te,class_labels_te] = BS3_GetHistograms(gvec,T,textons,no_dir,RIflag);
    [~,best_acc,best_fts_tie,no_ties] = GetBestClassifier(no_features,text_occ_tr,class_labels_tr,text_occ_te,class_labels_te);
    best_acc_vec(t) = best_acc;
    best_fts{t} = best_fts_tie;
    no_ties_vec(t) = no_ties;
end
