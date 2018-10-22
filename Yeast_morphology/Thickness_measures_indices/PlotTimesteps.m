function PlotTimesteps(S)

% 19 July 2016
%
% For sample S, plots the yeast sample for each timestep, t = {1,2,...,8}.

load 'rawdata.mat'
T = [23,48,73,87,115,162,211,233];
figure;
for t = 1:8
    time = T(t);
    str = ['$t=',int2str(time),'$ hours'];
    subplot(4,2,t); plotter(t,S); title(str,'interpreter','latex','fontsize',30)
end
%suptitle(['Sample ' int2str(S)])
    