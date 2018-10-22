function no_times = BS3_CountFeatures(best_fts,feature_label)

% 12 April 2017
%
% For a cell of best features, where each row is a vector of all features
% that tied for the best accuracy, counts the number of times feature
% with label feature_label is picked. no_times is the number of times that
% feature is picked.

[no_trials,~] = size(best_fts);
chosen_vec = zeros(no_trials,1);
for n = 1:no_trials
    tied_fts = best_fts{n};
    chosen_vec(n) = sum(tied_fts == feature_label);
end
no_times = sum(chosen_vec);