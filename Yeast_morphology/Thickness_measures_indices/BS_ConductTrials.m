function [best_acc_vec,best_fts_vec] = BS_ConductTrials(group1,group2,t1,t2,no_dir,k,no_features,no_trials)

% 14 December 2016
%
% A function that conducts no_trials trials of an experiment that
% differentiates between two strains (BS). 
%
% group1 and group2 are strings, giving the name of the strain. Choose from
% 'AWRI796_50um,' 'AWRI796_500um,' or 'AWRIR2_50um.' t1 and t2 are the
% timesteps that we want to use for group 1 and group 2 respectively. no_dir
% is the number of directions in which the thicknesses were measured for
% the oriented thickness textons. k is the number of clusters per class.
% no_features is the number of features we want to use for classification.

best_acc_vec = zeros(no_trials,1);
best_fts_vec = zeros(no_trials,no_features);
for t = 1:no_trials
    disp(['Now conducting trial ',int2str(t)])
    textons = BS_GetTextons(group1,group2,t1,t2,no_dir,k);
    [text_occ_g1_tr,text_occ_g2_tr,text_occ_g1_te,text_occ_g2_te] = BS_GetHistograms(group1,group2,t1,t2,textons,no_dir);
    [~,best_acc,best_fts] = BS_GetBestClassifier(no_features,text_occ_g1_tr,text_occ_g2_tr,text_occ_g1_te,text_occ_g2_te);
    best_acc_vec(t) = best_acc;
    best_fts_vec(t,:) = best_fts;
end