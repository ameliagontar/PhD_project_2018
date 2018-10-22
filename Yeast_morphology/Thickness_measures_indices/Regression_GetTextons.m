function primitives = Regression_GetTextons(strain,no_timesteps,no_samples)
%[primitives,textons] = Regression_GetTextons(strain,no_timesteps,no_samples,k)

% 15 February 2017
%
% For all 80 images in the data set for one strain, loads all 
% primitives, and clusters them into k clusters. The centres of these 
% clusters will be textons for regression to predict the time step. strain
% is a string of the name of the strain we are interested in. no_timesteps
% is the number of time steps for that strain. no_samples is the number of
% samples for that strain. k is the number of clusters used during k-means
% clustering.
%
% EDIT 23 February 2017: edited to just load all primitives for each
% strain, so that textons can later be computed for ALL three strains
% together. 

sdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/OTT_indices/Primitives_thickness_',strain,'/D12/NRI'];
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/OTT_indices';

primitives = [];
for t = 1:no_timesteps
    cd(sdir)
    newdir = ['t',int2str(t)];
    cd(newdir)
    for s = 1:no_samples
        sample = int2str(s);
        if length(sample) == 1
            filename = ['sample0',sample,'.mat'];
        elseif length(sample) == 2
            filename = ['sample',sample,'.mat'];
        else
            warning('Something went wrong!')
        end
        eval(['load ' filename])
        primitives = [primitives;prims];
    end
    cd(hdir)
end

%[~,textons] = kmeans(primitives,k);