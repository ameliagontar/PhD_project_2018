function Rdata = FindAllRadiiR

% 25 October 2016
%
% A function that returns the matrix Rdata. Column s and row t corresponds
% t the radius R for sample s and time t.

load rawdata.mat
Rdata = zeros(8,10);
for t = 1:8
    for s = 1:10
        im = rawdata(:,:,t,s);
        R = FindRadiusR(im);
        Rdata(t,s) = R;
    end
end