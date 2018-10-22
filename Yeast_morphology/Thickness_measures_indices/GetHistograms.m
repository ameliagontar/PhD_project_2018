function [text_occ_tr,class_labels_tr,text_occ_te,class_labels_te] = GetHistograms(dataset,no_dir,textons,RIflag,Rflag,Nflag)

% 9 August 2016
%
% Calculates the histogram of texton occurrences for each image in each
% experimental group. no_dir is the number of directions (parameter), 
% RIflag is the rotation invariance flag. RIflag = 1 if rotation invariance
% is on, RIflag = 0 if rotation invariance is off. Rflag is the random 
% flag. Rflag = 1 if randomised experiment on, Rflag = 0 if randomness off.
%
% EDIT 31 October 2016: Currently edited so that the histograms have the
% three metrics from Binder 2015 appended to the end. 
%
% EDIT 15 November 2016: poss is the "possibility number," corresponding to
% each possibility of arranging three objects. It is an integer
% corresponding to the numerical index of the possibility. 
%
% EDIT 21 November 2016: the variable poss has now been removed. Nflag is 
% the "normalisation flag." Nflag = 1 if the primitive vectors are to be
% normalised as in the Pattern Recognition paper, Nflag = 0 if the default
% implementation of textons is to be used. Dflag is the density flag. Dflag
% = 1 if the density feature is to be appended to the end of each
% feature vector, Dflag = 0 if only the texton occurrences are to be used 
% as features.
%
% EDIT 7 December 2016: The variable dataset was included, so that we can 
% run the classification on any of the three data sets provided by Ben and
% Hayden. dataset is a string, either 'AWRI796_50um,' 'AWRI796_500um,' or
% 'AWRIR2_50um.' The directories have also been updated to the new format.
% The variable Dflag was removed.

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

% Load set assignments and spatial indices:
filename_sa = ['set_assignments_',dataset,'.mat'];
cd(sdir1)
eval(['load ' filename_sa ' set_assignments'])
cd(hdir)
filename_ir = ['I_r_',dataset,'.mat'];
filename_iangular = ['I_angular_',dataset,'.mat'];
filename_itheta = ['I_Theta_',dataset,'.mat'];
cd('Index_arrays')
I_r = importdata(filename_ir);
I_angular = importdata(filename_iangular);
I_Theta = importdata(filename_itheta);
cd(hdir)
[n,~] = size(textons);

% Set up timepoints at which to take data, and set up training and testing
% histogram arrays:
[no_samples,no_timesteps] = size(set_assignments);
if strcmp(dataset,'AWRI796_50um')
    timevec = 1:no_timesteps;
elseif strcmp(dataset,'AWRI796_500um') || strcmp(dataset,'AWRIR2_50um')
    timevec = [1:5,7,9,10];
end
L = length(timevec);
no_training = ceil(no_samples/2);
no_testing = no_samples-no_training;
text_occ_tr = zeros(no_training*L,n+3);
text_occ_te = zeros(no_testing*L,n+3);
class_labels_tr = zeros(no_training*L,1);
class_labels_te = zeros(no_testing*L,1);

% Compute the histograms of texton occurrences:
m = 0;
for t = timevec
    m = m+1;
    newdir = ['t',int2str(t)];
    text_occ_tr_t = zeros(no_training,n+3);
    class_labels_tr_t = t*ones(no_training,1);
    text_occ_te_t = zeros(no_testing,n+3);
    class_labels_te_t = t*ones(no_testing,1);
    assgns = set_assignments(:,t);
    for idx = 1:no_training
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
        cd(hdir)
        metric1 = I_r(t,s)/n;
        metric2 = I_angular(t,s)/n;
        metric3 = I_Theta(t,s)/n;
        Mvec = [metric1,metric2,metric3];
        %if poss == 1
        %    Mvec = [metric1,metric2,metric3];
        %elseif poss == 2
        %    Mvec = [metric1,metric3,metric2];
        %elseif poss == 3
        %    Mvec = [metric2,metric1,metric3];
        %elseif poss == 4
        %    Mvec = [metric2,metric3,metric1];
        %elseif poss == 5
        %    Mvec = [metric3,metric1,metric2];
        %elseif poss == 6
        %    Mvec = [metric3,metric2,metric1];
        %end
        if Nflag == 0
            prims_for_map = prims;
        elseif Nflag == 1
            prims_for_map = NormalisePrimitives(prims,10^(-13));
        else
            warning('Something went wrong with indexing!')
        end
        text_occ = GetTextonMap(prims_for_map,textons);
        text_occ_tr_t(idx,:) = [text_occ,Mvec];
    end
    for idx = no_training+1:no_samples
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
        cd(hdir)
        metric1 = I_r(t,s)/n;
        metric2 = I_angular(t,s)/n;
        metric3 = I_Theta(t,s)/n;
        Mvec = [metric1,metric2,metric3];
        %if poss == 1
        %    Mvec = [metric1,metric2,metric3];
        %elseif poss == 2
        %    Mvec = [metric1,metric3,metric2];
        %elseif poss == 3
        %    Mvec = [metric2,metric1,metric3];
        %elseif poss == 4
        %    Mvec = [metric2,metric3,metric1];
        %elseif poss == 5
        %    Mvec = [metric3,metric1,metric2];
        %elseif poss == 6
        %    Mvec = [metric3,metric2,metric1];
        %end
        if Nflag == 0
            prims_for_map = prims;
        elseif Nflag == 1
            prims_for_map = NormalisePrimitives(prims,10^(-13));
        else
            warning('Something went wrong with indexing!')
        end
        text_occ = GetTextonMap(prims_for_map,textons);
        text_occ_te_t(idx-no_training,:) = [text_occ,Mvec];
    end
    text_occ_tr(no_training*(m-1)+1:no_training*m,:) = text_occ_tr_t;
    text_occ_te(no_testing*(m-1)+1:no_testing*m,:) = text_occ_te_t;
    class_labels_tr(no_training*(m-1)+1:no_training*m,:) = class_labels_tr_t;
    class_labels_te(no_testing*(m-1)+1:no_testing*m,:) = class_labels_te_t;
end
    