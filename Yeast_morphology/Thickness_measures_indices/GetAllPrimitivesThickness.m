function GetAllPrimitivesThickness(no_dir,stepsize,RIflag,Rflag,dataset,t,resrat)

% 8 August 2016
%
% Computes "pattern primitives" for all images contained in rawdata.mat.
% The thicknesses are measured at no_dir directions using a step size of
% stepsize. RIflag = 1 if rotation invariance is on and RIflag = 0 if
% rotation invariance is off. Rflag is the random flag. Rflag = 1 if
% randoness on, Rflag = 0 if randomness off. Assumes the randomised 
% experiment is conducted with no rotation invariance.
%
% EDIT 30 November 2016: The variable dataset was included. The input
% should be a string specifying which yeast data set should be referred to,
% chosen from 'AWRI796_50um,' 'AWRI796_500um' or 'AWRIR2_50um.' Also edited
% to take into account the differences in resolution in a generalised way.
%
% EDIT 31 March 2017: Edited so that one timepoint t needs to be entered
% only, for each data set. This enables us to take the last time point
% only. resrat is the resolution ratio, i.e. the ratio used to convert the
% number of pixels to an absolute length in micrometres. This ratio will be 
% slightly different for each data set. 

% Give a warning if dataset string entered incorrectly:
if ~(strcmp(dataset,'AWRI796_50um') || strcmp(dataset,'AWRI796_500um') || strcmp(dataset,'AWRIR2_50um'))
    warning('Dataset name entered incorrectly!')
end

% Set up the directories automatically:
Primdir = ['Shape_primitives_',dataset,'/'];
Ddir = ['D',int2str(no_dir),'/'];
if RIflag == 1 && Rflag == 0 
    RIdir = 'RI';
elseif RIflag == 0 && Rflag == 0
    RIdir = 'NRI';
elseif RIflag == 0 && Rflag == 1
    RIdir = 'Random';
else
    warning('Something went wrong with setup of experiment!')
end
sdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/DataSets/',dataset,'_Ammonium_Sulphate'];
tdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/OTT_indices/',Primdir,Ddir,RIdir];
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/OTT_indices';

% Create the arrays of primitives:
filename_dataset = ['rawdata_',dataset,'.mat'];
cd(sdir)
eval(['load ' filename_dataset ' rawdata'])
cd(hdir)
sz = size(rawdata);
%no_timesteps = sz(3);
no_samples = sz(4);
%for t = 1:no_timesteps
    newdir = ['t',int2str(t)];
    for s = 1:no_samples
        im = rawdata(:,:,t,s);
        %if strcmp(dataset,'AWRI796_50um') && (t == 1||t == 2)
        %    scale_factor = 2/5;
        %elseif strcmp(dataset,'AWRI796_500um') && t == 1
        %    scale_factor = 2/5;
        %elseif strcmp(dataset,'AWRIR2_50um') && (t == 1||t == 2)
        %    scale_factor = 2/5;
        %else 
        %    scale_factor = 1;
        %end
        prims = GetPrimitivesThickness(no_dir,stepsize,im,RIflag,resrat);
        %prims = scale_factor*prims;
        cd(tdir)
        cd(newdir)
        sample = int2str(s);
        if length(sample) == 1
            filename = ['sample0',sample,'.mat'];
        elseif length(sample) == 2
            filename = ['sample',sample,'.mat'];
        else 
            warning('Something went wrong!')
        end
        eval(['save ' filename ' prims'])
        cd(hdir)
    end
%end
    