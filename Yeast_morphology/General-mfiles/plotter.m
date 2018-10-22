%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plotter(t,s,rawdata)

% A function for plotting binary data extracted from yeast colonies,
% contained in rawdata.mat. t is the timepoint, t={1,..,8}, and s is the
% sample number, s={1,..,10}. From Ben Binder and Hayden Tronnolone at
% Adelaide Uni. Edited by Amelia 30 June 2016.

% Clear the current figure:
%clf;
%figure;

%load in data

%load rawdata.mat rawdata;

M=rawdata(:,:,t,s);
T = [23, 48, 73, 87, 115, 162, 211, 233];
%Plot colony

imagesc([0,1600],[0,1200],M); colormap gray; axis image; axis off
title(['$t=',int2str(T(t)),'$ hours'],'interpreter','latex','fontsize',16);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%