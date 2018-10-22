function RandomiseFeatureArrays

% 13 April 2016
%
% A program that randomly permutes the labels of each of the feature arrays
% in the folder 'FeatureArrays.' The feature arrays with the new permuted
% labels are saved in 'FeatureArrays_random.'

sdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/FeatureArrays';
tdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/FeatureArrays_random';
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles';

cd(sdir) 
curdir = dir;
no_files = length(curdir)-2;
if no_files == 90
    p = randperm(no_files);
    for k = 1:no_files
        idx = p(k);
        old_filename = curdir(idx+2).name;
        eval(['load ' old_filename])    % loads the feature array corresponding to the old 
                                        % filename. Called thetamat.
        new_filename = curdir(k+2).name;
        cd(tdir)
        eval(['save ' new_filename ' thetamat'])
        cd(sdir)
    end
else 
    warning('Check for .DS_store files.')
end
cd(hdir)