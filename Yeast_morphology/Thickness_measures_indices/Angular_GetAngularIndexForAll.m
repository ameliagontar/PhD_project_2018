function I_theta = Angular_GetAngularIndexForAll(M)

% 31 October 2016
%
% Computes the angular index of filamentation for all images contained in
% rawdata.mat, and stores them in a t x s array.

load rawdata.mat
load RCSRdata.mat
I_theta = zeros(8,10);
for t = 1:8
    for s = 1:10
        im = rawdata(:,:,t,s);
        Rcsr = RCSRdata(t,s);
        [~,F_theta] = Angular_GetAngularMetric(im,Rcsr,M);
        [~,~,ang_idx] = Angular_GetAngularIndex(F_theta);
        I_theta(t,s) = ang_idx;
    end
end
        