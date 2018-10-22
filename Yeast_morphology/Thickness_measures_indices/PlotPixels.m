function PlotPixels(S,ignoreflag)

% 19 July 2016
%
% For each sample S, loads the 2D binary yeast image for every timestep
% t = {1,2,...8}, finds and counts the number of boundary pixels, and plots
% Cratio against time. ignoreflag tells the program whether or not to 
% ignore t = 2, which seems to be anomalous (picture taken badly?), with 1 
% meaning ignore, 0 meaning do not ignore. If using CRatio, do not ignore.

load 'rawdata.mat'
if ignoreflag == 1
    tvec = [1,3,4,5,6,7,8];
    ratiovec = zeros(1,7);
else 
    tvec = 1:8;
    ratiovec = zeros(1,8);
end

k = 0;
for t = tvec
    k = k+1;
    smpl = rawdata(:,:,t,S);
    [~,Cratio,~] = FindPixels(smpl);
    ratiovec(k) = Cratio;
end

plot(tvec,ratiovec,'bx','linewidth',2)
xlabel('Timestep')
ylabel('Cratio')
title(['Sample ' int2str(S)],'fontsize',12);