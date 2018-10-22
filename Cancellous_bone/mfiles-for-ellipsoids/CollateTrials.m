function CollateTrials(no_trials,no_features,expmt)

% 24 November 2016

sdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles-for-ellipsoids/Results_temporary/',expmt];
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles-for-ellipsoids';

cd(sdir)
best_acc_vec = zeros(no_trials,1);
best_fts_vec = zeros(no_trials,no_features);
filename_best_acc_vec = 'best_acc_vec_R2.mat';
filename_best_fts_vec = 'best_fts_vec_R2.mat';
for t = 1:no_trials
    filename_best_acc = ['best_acc_R2_t',int2str(t),'.mat'];
    filename_best_fts = ['best_fts_R2_t',int2str(t),'.mat'];
    eval(['load ' filename_best_acc]) 
    eval(['load ' filename_best_fts]) 
    best_acc_vec(t) = best_acc;
    best_fts_vec(t,:) = best_fts;
end
eval(['save ' filename_best_acc_vec ' best_acc_vec'])
eval(['save ' filename_best_fts_vec ' best_fts_vec'])
cd(hdir)