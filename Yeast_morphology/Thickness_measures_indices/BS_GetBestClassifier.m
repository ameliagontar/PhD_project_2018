function [acc_vec,best_acc,best_fts] = BS_GetBestClassifier(no_features,text_occ_g1_tr,text_occ_g2_tr,text_occ_g1_te,text_occ_g2_te)

% 14 December 2016
%
% A program that uses the Fisher classifier (a form of LDA for two classes)
% to classify yeast colony data for one timestep only. This may need to be
% refined later, to include features from additional timesteps, or to use a
% different classifier (more to choose from when there are two classes).
% This classification is intended to differentiate between strains (BS).
% This program uses exhaustive search to find the best combination of
% no_features features.
%
% best_acc is the best accuracy obtained after exhaustive search of the
% best features. best_fts is the combination of features that corresponds
% to this highest accuracy. If there is more than one best accuracy, then
% the program takes the LAST of these values. i.e. for the largest indexed
% feature (or combination of features) that achieved this.
%
% NOTE: an accuracy value is probably not the best way to evaluate the 
% results, because there may be an uneven number of images from each class
% in the testing set. Think about how to evaluate the results (ROC curve?)
% later. Refine the experimental method too? How? 

test = [text_occ_g1_te;text_occ_g2_te];
[no_g1_te,~] = size(text_occ_g1_te);
[no_g2_te,~] = size(text_occ_g2_te);
class1 = ones(no_g1_te,1);
class2 = 2*ones(no_g2_te,1);
true_class = [class1;class2];
[~,TF] = size(text_occ_g1_tr);
v = 1:TF;
C = nchoosek(v,no_features);
[L,~] = size(C);
acc_vec = zeros(L,1);
best_acc = 0;
for l = 1:L
    fts_idx = C(l,:);
    g1 = text_occ_g1_tr(:,fts_idx);
    g2 = text_occ_g2_tr(:,fts_idx);
    test_features = test(:,fts_idx);
    fisher_class = FisherDir(g1,g2,test_features);
    acc = sum(fisher_class == true_class)/length(true_class);
    acc_vec(l) = acc;
    if acc >= best_acc
        best_acc = acc;
        best_fts = fts_idx;
    end
end
    