function H = GetHistograms(textons)

% 27 January 2017
%
% Computes histograms of texton occurrences, one for each cow. The output H
% is an array of size 20 x k, where each row is a texton histogram for one
% cow (cow 1, cow 2, cow 3, ...)

sdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Marbling/mfiles/Primitives_OneBP';
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Marbling/mfiles';

[n,~] = size(textons);
H = zeros(20,n);
for C = 1:20
    cow_number = int2str(C);
    if length(cow_number) == 1
        filename = ['cow10',cow_number,'.mat'];
    elseif length(cow_number) == 2
        filename = ['cow1',cow_number,'.mat'];
    end
    cd(sdir) 
    eval(['load ' filename])
    cd(hdir)
    text_occ = GetTextonMap(prims,textons);
    H(C,:) = text_occ;
end