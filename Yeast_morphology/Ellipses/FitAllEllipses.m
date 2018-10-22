function FitAllEllipses(threshold,r)

% 6 September 2016
%
% Fits a set of threshold ellipses using balls of radius r, for each
% timestep for each sample. These will be used to compute the 'primitives'
% later. 

tdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/Ellipse_fits';
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology';
newdir = ['R',int2str(r)];
load rawdata.mat

for s = 1:10
    for t = 1:8
        im = rawdata(:,:,t,s);
        [~,~,~,filaments] = FindRadius(im);
        ellipses = FitEllipseSubsample(im,filaments,threshold,r,t);
        filename = ['Sample',int2str(s),'_Timestep',int2str(t)];
        cd(tdir)
        cd(newdir)
        eval(['save ' filename ' ellipses'])
        cd(hdir)
    end
end
