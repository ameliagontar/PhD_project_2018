function PlotPixelsforAll(ignoreflag)

% 19 July 2016
%
% Loads all samples, and plots the number of boundary pixels against
% timestep for all samples in one subplot. ignoreflag tells the program
% whether or not to ignore t = 2, which seems to be anomalous (picture
% taken badly?), with 1 meaning ignore, 0 meaning do not ignore. The
% samples are s = {1,2,...,10}.

figure;
for S = 1:10
    subplot(2,5,S)
    PlotPixels(S,ignoreflag)
end