function [best_acc,best_fts] = GetBestClassifier(no_features,text_occ_tr,class_labels_tr,text_occ_te,class_labels_te)

% 30 June 2016
%
% Conducts LDA on every possible combination of no_features features, and 
% chooses the best classification accuracy.

[~,N] = size(text_occ_tr);
v = 1:N;
C = nchoosek(v,no_features);
[L,~] = size(C);
acc_vec = zeros(L,1);
fts_vec = zeros(L,no_features);
k = 0;
for l = 1:L
    fts = C(l,:);
    fvec_tr = text_occ_tr(:,fts);
    fvec_te = text_occ_te(:,fts);
    try
        obj = fitcdiscr(fvec_tr,class_labels_tr);
        label = predict(obj,fvec_te);
        tf = strcmp(label,class_labels_te);
        acc = sum(tf)/length(tf);
        k = k+1;
        acc_vec(k) = acc;
        fts_vec(k,:) = fts;
    catch
        warning('Something went wrong with LDA! Moving on to next combination of features.')
    end
end
acc_vec = acc_vec(1:k);
fts_vec = fts_vec(1:k,:);
[best_acc,idx] = max(acc_vec);
best_fts = fts_vec(idx,:);