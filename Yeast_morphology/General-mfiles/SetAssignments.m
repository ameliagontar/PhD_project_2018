function set_assignments = SetAssignments(dataset)

% 21 July 2016
%
% Sets the assignments for the training and testing groups. In the yeast
% morphology data, there are 8 experimental groups, each corresponding to
% one timestep. In each group, there are 10 samples. For each group,
% randomly permute the numbers {1,...,10}, and take the first five of these
% as the training set and the last five as the testing set. This method of
% assigning the samples to the training and testing sets means that the
% samples are mixed up, but more thoroughly tests whether we can classify
% into the 8 experimental groups based on timestep (therefore shape?) alone
% (independent of sample number). 
%
% set_assignments is a 10x8 array. Each column k lists the training vs
% testing assignments for timestep k. The first 5 sample numbers correspond
% to training and the last five sample numbers correspond to testing
% samples for that group.
%
% EDIT 1 December 2016: edited to include the variable dataset, which is a
% string, either 'AWRI796_50um,' 'AWRI796_500um,' or 'AWRIR2_50um.' Then
% loads the appropriate data set to generate random assignments to the
% training and testing set.

sdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/DataSets';
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/General-mfiles';
newdir = [dataset,'_Ammonium_Sulphate'];
filename = ['rawdata_',dataset,'.mat'];

cd(sdir)
cd(newdir)
eval(['load ' filename ' rawdata'])
cd(hdir)
sz = size(rawdata);
no_timesteps = sz(3);
no_samples = sz(4);

set_assignments = zeros(no_samples,no_timesteps);
for k = 1:no_timesteps
    p = randperm(no_samples);
    set_assignments(:,k) = p';
end