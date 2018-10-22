function [best_acc_vec,best_fts_vec] = ConductExperiment(R,k,no_features,T)

% 30 June 2016 (Edited 24 August 2016)
%
% Conducts an entire classification experiment, assuming primitives have
% already been obtained for the given ball radius R. k is the number of 
% clusters per class. no_features is the number of features used for 
% classification, and T is the number of trials (i.e. the number of times 
% we repeat the experiment, where k-means clustering is the stochastic
% step).  
% 
% EDIT: After each trial, the program saves the current best_acc_vec to the
% folder 'Results_temporary,' in case the program needs to be stopped for 
% whatever reason. Allows us to recover the results for the trials that 
% have been conducted so far.

tdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles-for-ellipsoids/Results_temporary';
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles-for-ellipsoids';

best_acc_vec = zeros(T,1);
best_fts_vec = zeros(T,no_features);
for t = 1:T
    disp(['Now conducting trial ' int2str(t)])
    textons = GetTextons(R,k);
    [text_occ_tr,class_labels_tr,text_occ_te,class_labels_te] = GetTextonHist(R,textons);
    [best_acc,best_fts] = GetBestClassifier(no_features,text_occ_tr,class_labels_tr,text_occ_te,class_labels_te);
    best_acc_vec(t) = best_acc;
    best_fts_vec(t,:) = best_fts;
    cd(tdir)
    save('best_acc_vec.mat','best_acc_vec')
    cd(hdir)
end