function no_times_chosen = LOOCV_CountFeatures(best_fts_folds,feature_label)

% 6 April 2017
%
% Counts the number of times the feature with label feature_label was 
% chosen as one of the best features for the classification of each 'fold'.
% This is used to count the number of times Ben and Hayden's spatial
% indices were chosen to classify each fold in each LOOCV classification
% experiment. Note that this program does not take into account repeats,
% i.e. if more than one feature performed equally well, then both features
% will be counted. Returns the number of times that feature was chosen as
% ONE OF the best features. 
%
% Note that counting the number of times textons were used as features does
% not make any sense, because the textons are re-computed for every run of
% the cross validation (i.e. every fold). This program assumes that
% feature_label is already the label corresponding to one of the spatial
% indices, and that only one feature was used for classification. Could be
% generalised later, if needed.

[no_folds,~] = size(best_fts_folds);
all_counts = zeros(no_folds,1);
for f = 1:no_folds
    fvec = best_fts_folds{f};
    all_counts(f) = sum(fvec == feature_label);
end
no_times_chosen = sum(all_counts);    