function H = Regression_GetHistograms(strain,no_timesteps,no_samples,textons)

% 15 February 2017
%
% For each strain, computes an array of (normalised) histogram of texton 
% occurrences. Each row corresponds to one image. The images are ordered by
% time first, then sample. In other words, row 1 corresponds to time = 1,
% sample = 1, row 2 corresponds to time = 1, sample = 2, ...
% 
% strain is a string of the name of the strain we are interested in.
% no_timesteps and no_samples are the number of time steps and samples for
% that strain, respectively. textons is the array of textons for that
% strain - it is traceable and has been calculated previously. Load from
% the same directory as this program. H is the array of normalised
% histograms.

hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/OTT_indices';
sdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/OTT_indices/Primitives_thickness_',strain,'/D12/NRI'];

[k,~] = size(textons);
H = zeros(no_timesteps*no_samples,k);
m = 0;
for t = 1:no_timesteps
    cd(sdir)
    newdir = ['t',int2str(t)];
    cd(newdir)
    for s = 1:no_samples
        m = m+1;
        sample = int2str(s);
        if length(sample) == 1
            filename = ['sample0',sample,'.mat'];
        elseif length(sample) == 2
            filename = ['sample',sample,'.mat'];
        end
        eval(['load ' filename])
        cd(hdir)
        histogram = GetTextonMap(prims,textons);
        cd(sdir)
        cd(newdir)
        H(m,:) = histogram;
    end
end
cd(hdir)
