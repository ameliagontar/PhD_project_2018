function textons = GetTextonsForEllipses(r,k)

% 8 September 2016
%
% For the set of fitted ellipses and for each of the eight classes, takes 
% all primitive vectors for the training set and clusters them using 
% k-means clustering. Then, contatenates the textons from each class to 
% form a texton dictionary of size 8k. r is the radius of the balls used 
% to fit the current set of ellipses.

sdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/Primitives_colonylengths_only';
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology';
newdir = ['R',int2str(r)];

load set_assignments.mat    % variable has name set_assignments

textons = zeros(8*k,2);
for t = 1:8
    primitives = [];
    assigns = set_assignments(:,t);
    for i = 1:5
        s = assigns(i);
        filename = ['Sample',int2str(s),'_Timestep',int2str(t)];
        cd(sdir)
        cd(newdir)
        eval(['load ' filename])    % variable has name prims
        cd(hdir)
        primitives = [primitives;prims];
    end
    [~,textons_group] = kmeans(primitives,k);
    textons((t-1)*k+1:t*k,:) = textons_group;
end

