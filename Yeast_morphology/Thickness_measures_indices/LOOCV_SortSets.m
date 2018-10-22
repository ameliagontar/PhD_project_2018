function idx_array = LOOCV_SortSets(gvec)

% 4 April 2017
%
% A program that sorts out the indexing used to load the correct sample for
% leave-one-out cross-validation (LOOCV). idx_array is an array of size 
% <total number of samples in the problem> x 2. The first column is the 
% class label and the second column is ths sample number for that class. 
% The LOOCV will use this array to choose the appropriate sample to discard
% when getting the training set. gvec is a cell with one row and length 
% equal to the number of groups. Each entry in the cell is a string 
% specifying the group name.
%
% Class label #1 corresponds to the first group entered in gvec, class
% label #2 corresponds to the second group entered in gvec, and so on.

hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/OTT_indices';
sdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/DataSets';

no_groups = length(gvec);
idx_array = [];
for G = 1:no_groups
    group_name = gvec{G};
    newdir = [group_name,'_Ammonium_Sulphate'];
    cd(sdir)
    cd(newdir)
    data_name = ['rawdata_',group_name,'.mat'];
    eval(['load ' data_name])
    cd(hdir)
    sz = size(rawdata);
    no_samples = sz(4);
    class_label = G*ones(no_samples,1);
    sample_number = (1:no_samples)';
    idx = [class_label,sample_number];
    idx_array = [idx_array;idx];
end