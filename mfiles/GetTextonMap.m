function text_occ = GetTextonMap(prims,textons)

% 9 August 2016 (Edited 27 January 2017 for steak example)
% 
% Finds the histogram of texton occurrences for one image. prims is the 
% array of primitives for that image and textons is the array of textons.
% text_occ is the row vector of (normalised) texton occurrences for that
% image (size 1 x k).

[L,~] = size(prims);
[n,~] = size(textons);

% Map each primitive to the closest texton and get a texton map:
textonmap = zeros(L,1);
for l = 1:L
    curr_primitive = prims(l,:);
    dists = zeros(n,1);
    for i = 1:n
        dists(i) = norm(textons(i,:)-curr_primitive);
    end
    [~,idx] = min(dists);
    textonmap(l) = idx;
end

% Get the histogram of texton occurrences:
texton_no = hist(textonmap,1:n);
text_occ = texton_no/sum(texton_no);