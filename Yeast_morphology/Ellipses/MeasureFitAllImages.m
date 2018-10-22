function [measures,labels] = MeasureFitAllImages(r)

% 5 January 2017
%
% Gets a measure of fit for all ellipsoids fit to all 80 images in the data
% set, and lists them in a column vector. This will allow us to compute the
% mean and standard deviation of the MOF, as a function of r, so that we 
% can judge which ellipsoids fit the data best. measures is a column vector
% of all of the measures of fit for all ellipsoids for all 80 images.
% labels is an array of corresponsing sample and time labels. Column 1
% corresponds to the sample number and column 2 corresponds to the
% timestep.

sdir1 = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/DataSets/AWRI796_50um_Ammonium_Sulphate';
sdir2 = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/Ellipses/Ellipse_fits/R',int2str(r)];
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/Ellipses';

cd(sdir1)
load rawdata_AWRI796_50um.mat
cd(hdir)

measures = [];
sample_labels = [];
time_labels = [];

for s = 1:10
    for t = 1:8
        disp(['Now calculating MOFs for sample ',int2str(s),', timestep ',int2str(t)]);
        im = rawdata(:,:,t,s);
        filename_ellipse = ['Sample',int2str(s),'_Timestep',int2str(t),'.mat'];
        cd(sdir2)
        eval(['load ' filename_ellipse])
        cd(hdir)
        all_MOF = MeasureFitAllEllipses(im,ellipses);
        measures = [measures;all_MOF];
        [no_ellipses,~] = size(ellipses);
        sample = s*ones(no_ellipses,1);
        time = t*ones(no_ellipses,1);
        sample_labels = [sample_labels;sample];
        time_labels = [time_labels;time];
    end
end
labels = [sample_labels,time_labels];
        
        