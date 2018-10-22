function [best_acc_folds,best_fts_folds,no_ties_vec,acc_score] = LOOCV_ConductExperiment(idx_array,gvec,T,no_dir,k,no_features)

% 4 April 2017
%
% Conducts an entire leave-one-out classification experiment. Gets one
% classification accuracy (binary) for each fold (i.e. each instance of a
% sample being left out of the training set). best_acc_folds is a vector of
% length corresponding to the total number of samples in the experiment.
% Each entry corresponds to the accuracy obtained when classifying that
% corresponding fold (0 or 1, since we are classifying only one sample).
% best_fts_folds is the combination of best features used to classify that
% fold, used to check whether the spatial indices were ever selected. The
% folds are left out in numerical order.

[total_samples,~] = size(idx_array);
best_acc_folds = zeros(total_samples,1);
best_fts_folds = cell(total_samples,1);
no_ties_vec = zeros(total_samples,1);
for n = 1:total_samples
    disp(['Now classifying sample ',int2str(n),' of ',int2str(total_samples)])
    [best_acc,best_fts_tie,no_ties] = LOOCV_LeaveOneOut(idx_array,n,gvec,T,no_dir,k,no_features);
    best_acc_folds(n) = best_acc;
    best_fts_folds{n} = best_fts_tie;
    no_ties_vec(n) = no_ties;
end
acc_score = sum(best_acc_folds)/total_samples;