function R_max = FindMaxRadius

% 26 September 2016
%
% For all images stored in rawdata.mat, finds the 'maximum' radius and
% appends it to the vector R_max.

load 'rawdata.mat'
R_max = zeros(80,1);
k = 0;
for s = 1:10
    for t = 1:8
        k = k+1;
        im = rawdata(:,:,t,s);
        [~,~,r_max] = FindRadius(im);
        R_max(k) = r_max;
    end
end