function [best_acc_vec,best_fts_vec] = CollateTrialsAuxiliary(no_trials,no_features)

% 21 November 2016

sdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/Results_temporary';
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology';

cd(sdir)
best_acc_vec = zeros(no_trials,1);
best_fts_vec = zeros(no_trials,no_features);
for t = 1:no_trials
    filename_best_acc = ['best_acc_ST_t',int2str(t),'.mat'];
    filename_best_fts = ['best_fts_ST_t',int2str(t),'.mat'];
    eval(['load ' filename_best_acc]);
    eval(['load ' filename_best_fts]);
    best_acc_vec(t) = best_acc;
    best_fts_vec(t,:) = best_fts;
end
cd(hdir)
    