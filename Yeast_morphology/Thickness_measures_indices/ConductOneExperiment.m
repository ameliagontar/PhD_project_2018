function ConductOneExperiment(dataset,no_dir,k,no_features,trial_cnt,RIflag,Rflag,Nflag)

% 7 December 2016
%
% Conducts one trial/instance of the classification experiment, using
% oriented thickness textons plus possibly spatial indices of Ben and
% Hayden. 
%
% dataset is the name of the yeast colony data set that we are conducting
% the experiment on, no_dir is the number of directions that the oriented
% thickness textons are computed in, k is the number of clusters per class
% chosen while computing the textons, no_features is the number of features
% used for classification. RIflag is the rotation invariance flag, Rflag is
% the randomness flag, and Nflag is the normalisation flag, set to 1 if the
% textons need to be normalised for the auxiliary information experiments.
%
% trial_cnt is the trial counter, used for file naming and to save the best
% accuracy and best features for each of the trials. To be used in
% conjunction with another program or with Colossus in order to conduct
% multiple trials.

tdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/OTT_indices/Results/',dataset];
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/OTT_indices';

filename_best_acc = ['best_acc_D',int2str(no_dir),'_t',int2str(trial_cnt)];
filename_best_fts = ['best_fts_D',int2str(no_dir),'_t',int2str(trial_cnt)];
textons = GetTextons(dataset,no_dir,k,RIflag,Rflag,Nflag);
[text_occ_tr,class_labels_tr,text_occ_te,class_labels_te] = GetHistograms(dataset,no_dir,textons,RIflag,Rflag,Nflag);
[best_acc,best_fts] = GetBestClassifier(no_features,text_occ_tr,class_labels_tr,text_occ_te,class_labels_te);
cd(tdir) 
eval(['save ' filename_best_acc ' best_acc'])
eval(['save ' filename_best_fts ' best_fts'])
cd(hdir)