function [acc_vec,best_acc,best_fts_tie,no_ties] = GetBestClassifier(no_features,text_occ_tr,class_labels_tr,text_occ_te,class_labels_te)

% 30 June 2016 (Edited 9 August 2016)
%
% Conducts LDA on every possible combination of no_features features, and 
% chooses the best classification accuracy. This program is based on the
% equivalent program written for the classification of rat bone using
% ellipsoids. The program uses the new LDA classifier command in Matlab.
%
% EDIT 15 December 2016: edited so that, if there is a tie for the best
% classification accuracy (i.e. the highest classification accuracy occurs
% for more than one combination of features), then the last combination of
% features will be returned as the 'best.' This is so that we can check if
% the spatial features from Ben and Hayden, which are usually listed last, 
% give a best classification. However, the number of times that the best
% accuracy occurs is given by the scalar no_ties (number of ties).
%
% EDIT 12 April: rather than giving the last best feature, the program now
% gives a vector of all the features that tie for the best accuracy,
% best_fts_tie. The length of best_fts_tie should be the same as no_ties.
% If this is not the case, then the program returns a warning.

[~,N] = size(text_occ_tr);
v = 1:N;
C = nchoosek(v,no_features);
[L,~] = size(C);
acc_vec = zeros(L,1);
best_fts_tie = [];
best_acc = 0;
k = 0;
for l = 1:L
    fts = C(l,:);
    fvec_tr = text_occ_tr(:,fts);
    fvec_te = text_occ_te(:,fts);
    try
        obj = fitcdiscr(fvec_tr,class_labels_tr);
        label = predict(obj,fvec_te);
        tf = (label == class_labels_te);
        acc = sum(tf)/length(tf);
        k = k+1;
        acc_vec(k) = acc;
        if acc == best_acc
            best_acc = acc;
            best_fts_tie = [best_fts_tie,fts];
        elseif acc > best_acc
            best_acc = acc;
            best_fts_tie = [];
            best_fts_tie = [best_fts_tie,fts];
        end
    catch
        warning('Something went wrong with LDA! Moving on to next combination of features.')
    end
end
acc_vec = acc_vec(1:k);
no_ties = sum(acc_vec == best_acc);
M = length(best_fts_tie);
if ~(M == no_ties)
    warning('Something went wrong with the vector recording the tied best features - check again!')
end