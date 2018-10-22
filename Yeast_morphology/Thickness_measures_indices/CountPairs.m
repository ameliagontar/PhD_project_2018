function angle_cnt = CountPairs(im,ns,N)

% 18 August 2016
%
% An attempt to replicate Ben Binder's calculation of the angular
% pair-correlation metric from Binder et al. 2015. For one image im,
% subsamples ns occupied sites, then compares all pairs of these occupied
% sites. Counts the number of pairs that are separated by an angle of
% between 0 and pi/N radians, where N is the number of bins. ns = 1000 and
% N = 200 in Ben's experiment. Note that, since subsampling is stochastic,
% ns will be approximate.

% Find the coordinates of all on pixels:
[y_coords,x_coords] = find(im);
coords = [x_coords,y_coords];

% Find the centre of the yeast growth:
x_mean = mean(x_coords);
y_mean = mean(y_coords);

% Subsample aproximately ns of the on pixels:
S = sum(sum(im));
prop = ns/S;
[L,~] = size(coords);
coords_subsampled = zeros(2*ns,2);
k = 0;
for l = 1:L
    X = rand;
    if X < prop
        k = k+1;
        coords_subsampled(k,:) = coords(l,:);
    end
end
coords_subsampled = coords_subsampled(1:k,:);

% Get all possible pairs of coordinates and count the pairs with an angle 
% of less than pi/N between them:
choices = 1:k;
C = nchoosek(choices,2);
[M,~] = size(C);
angle_cnt = 0;
for m = 1:M
    pair_idx = C(m,:);
    c1 = coords_subsampled(pair_idx(1),:);
    c2 = coords_subsampled(pair_idx(2),:);
    v1 = [x_mean-c1(1),y_mean-c1(2)];
    v2 = [x_mean-c2(1),y_mean-c2(2)];
    cos_theta = (v1(1)*v2(1)+v1(2)*v2(2))/(norm(v1)*norm(v2));
    theta = acos(cos_theta);
    if theta >= 0 && theta < pi/N
        angle_cnt = angle_cnt+1;
    end
end