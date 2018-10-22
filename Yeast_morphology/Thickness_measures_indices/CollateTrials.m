function CollateTrials(dataset,no_dir,no_trials)

% 9 December 2016

sdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/OTT_indices/Results/',dataset];
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/OTT_indices';

cd(sdir)
best_acc_vec = zeros(no_trials,1);
best_fts_vec = zeros(no_trials,3);
filename_acc_vec = ['best_acc_vec_D',int2str(no_dir),'.mat'];
filename_fts_vec = ['best_fts_vec_D',int2str(no_dir),'.mat'];
for t = 1:no_trials
    filename_best_acc = ['best_acc_D',int2str(no_dir),'_t',int2str(t),'.mat'];
    filename_best_fts = ['best_fts_D',int2str(no_dir),'_t',int2str(t),'.mat'];
    eval(['load ' filename_best_acc])
    eval(['load ' filename_best_fts])
    best_acc_vec(t) = best_acc;
    best_fts_vec(t,:) = best_fts;
end
eval(['save ' filename_acc_vec ' best_acc_vec'])
eval(['save ' filename_fts_vec ' best_fts_vec'])
cd(hdir)