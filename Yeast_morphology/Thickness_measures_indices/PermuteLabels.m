function PermuteLabels(no_dir)

% 10 August 2016
%
% A function that randomly permutes all 80 labels (i.e. perumtes all labels
% regardless of time or sample number) and saves these new permuted labels
% in Primitives_<primitive type>_random. Need to change the directories,
% depending on which type of primitive is being used for the current
% experiment. This is one iteration of the permutation.

Ddir = ['D',int2str(no_dir)];
sdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/Primitives_thickness/',Ddir,'/NRI'];
tdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology/Primitives_thickness/',Ddir,'/Random'];
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Yeast-morphology';

% Create a "counter matrix" and random permutation matrix. The counter
% matrix is used to convert a sample number (out of 80) to a sample in
% terms of t and s.
cnt_matrix = 1:80;
cnt_matrix = reshape(cnt_matrix,10,8);
p = randperm(80);

% For each sample number, permute the label, load the new primitive array,
% and save this new primitive array as the original sample name:
for orig_sample_no = 1:80
    [s_orig,t_orig] = find(cnt_matrix==orig_sample_no);
    new_sample_no = p(orig_sample_no);
    [s_new,t_new] = find(cnt_matrix==new_sample_no);
    sample_new = int2str(s_new);
    if length(sample_new) == 1
        filename = ['sample0',sample_new];
    elseif length(sample_new) == 2
        filename = ['sample',sample_new];
    else
        warning('Something went wrong!')
    end
    newdir = ['t',int2str(t_new)];
    cd(sdir)
    cd(newdir)
    eval(['load ' filename])     % variable has name prims
    sample_orig = int2str(s_orig);
    if length(sample_orig) == 1
        newfilename = ['sample0',sample_orig];
    elseif length(sample_orig) == 2
        newfilename = ['sample',sample_orig];
    else
        warning('Something went wrong!')
    end
    newdir = ['t',int2str(t_orig)];
    cd(tdir)
    cd(newdir)
    eval(['save ' newfilename ' prims'])
    cd(hdir)
end