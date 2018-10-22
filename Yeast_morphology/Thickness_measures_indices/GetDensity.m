function Density = GetDensity

% 21 November 2016
%
% A function that calculates a density parameter for each of the colonies.
% The density parameter is analogous to the density parameter calculated
% for the cancellous bone, which acted as the auxiliary information in the
% Pattern Recognition paper. Here, the density parameter is the number of
% on pixels in the colony (i.e. effectively the area of the colony) divided
% by the area of the image. i.e. the density is the normalised area of the
% colony. To account for the difference in resolution, the density for 
% images at the first two timesteps is multiplied by (2/5)^2. The density
% values are saved in an 8 x 10 array, with the rows corresponding to the
% timestep and the columns corresponding to the sample number.

load rawdata.mat
Density = zeros(8,10);
for t = 1:8
    for s = 1:10
        im = rawdata(:,:,t,s);
        [a,b] = size(im);
        if t == 1 || t == 2
            scale_factor = (2/5)^2;
        else
            scale_factor = 1;
        end
        Density(t,s) = scale_factor*(sum(sum(im))/(a*b));
    end
end