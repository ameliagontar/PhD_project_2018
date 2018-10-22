function textons = GetTextons(dataset,no_dir,k,RIflag,Rflag,Nflag)

% 9 August 2016
%
% Computes textons for the yeast morphology data, using the training set of
% images as determined by set_assignments.mat. k is the number of clusters
% per class. no_dir is the number of directions (parameter), RIflag is the
% rotation invariance flag. RIflag = 1 if rotation invariance is on, RIflag
% = 0 if rotation invariance is off. Rflag is the random flag. Rflag = 1 if
% randomised experiment on, Rflag = 0 if randomness off. Nflag is the
% normalisation flag. Nflag = 1 if the textons are to be normalised (as in
% the Pattern Recognition paper), Nflag = 0 if we are using the default 
% implementation of textons.
%
% EDIT 5 December 2016: The variable dataset was included, so that we can 
% run the classification on any of the three data sets provided by Ben and
% Hayden. dataset is a string, either 'AWRI796_50um,' 'AWRI796_500um,' or
% 'AWRIR2_50um.' The directories have also been updated to the new format. 

% Set up the directories based on the current experiment:
Ddir = ['D',int2str(no_dir),'/'];
primdir = ['Primitives_thickness_',dataset,'/'];
if RIflag == 1 && Rflag == 0 
    RIdir = 'RI';
elseif RIflag == 0 && Rflag == 0
    RIdir = 'NRI';
elseif RIflag == 0 && Rflag == 1
    RIdir = 'Random';
else
    warning('Something went wrong with setup of experiment!')
end
sdir1 = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/General-mfiles';
sdir2 = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/OTT_indices/',primdir,Ddir,RIdir];
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/OTT_indices';

% Load set assignments:
filename_sa = ['set_assignments_',dataset,'.mat'];
cd(sdir1)
eval(['load ' filename_sa])
cd(hdir)
[no_samples,no_timesteps] = size(set_assignments);

% For the AWRI796_500um and AWRIR2_50um datasets, remove the data at t =
% 6,8, so that the timepoints match up closely between all three datasets:
if strcmp(dataset,'AWRI796_50um')
    timevec = 1:no_timesteps;
elseif strcmp(dataset,'AWRI796_500um') || strcmp(dataset,'AWRIR2_50um')
    timevec = [1:5,7,9,10];
end
L = length(timevec);
textons = zeros(L*k,no_dir);

% Compute the textons:
m = 0;
for t = timevec
    m = m+1;
    all_primitives = [];
    newdir = ['t',int2str(t)];
    assgns = set_assignments(:,t);
    for idx = 1:ceil(no_samples/2)
        s = assgns(idx);
        sample = int2str(s);
        if length(sample) == 1
           filename = ['sample0',sample];
        elseif length(sample) == 2
           filename = ['sample',sample];
        else
           warning('Something went wrong!')
        end
        cd(sdir2)
        cd(newdir)
        eval(['load ' filename])
        all_primitives = [all_primitives;prims];
        cd(hdir)
    end
    if Nflag == 0
        prims_to_cluster = all_primitives;
    elseif Nflag == 1
        prims_to_cluster = NormalisePrimitives(all_primitives,10^(-13));
    else
        warning('Something went wrong with indexing!')
    end
    [~,textons_for_class] = kmeans(prims_to_cluster,k);
    textons((m-1)*k+1:m*k,:) = textons_for_class;
end

        
    