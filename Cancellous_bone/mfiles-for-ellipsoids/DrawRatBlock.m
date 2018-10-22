function DrawRatBlock(data)

% 1 April 2015 - 7 April 2015
% A program that allows us to visualise the data in each data block, for 
% each rat at each recorded week, by drawing/plotting the on voxels. Uses
% Murk's code as an example. Also a good example for general plotting and
% axis setup. Could become useful later to visually check if
% skeletonisation seems to be working.

paperpos = [1 1 16 6];
%screenpos = [200 200 300 800]; % for actual rat data
screenpos = [200 200 600 600]; % better for my toy examples
figure('position',screenpos,'paperposition',paperpos) % sets up and 'activates' the figure; will be useful in other situations.

%subplot('position',[0 0 1 1])  % makes the axes first, and adds 3D plot/patch afterwards. Better settings for rat bone.
subplot('position',[.02 .02 .97 .97])  % better for toy examples, especially for ellipsoid fitting.  

patch(isosurface(data,.5),'FaceColor',[1,.45,.35],'EdgeColor','none')   % isosurface is a command that draws a 3D data array by computing faces and vertices
view(220,10)
lightangle(220,10)
set(gcf,'Renderer','zbuffer');
lighting phong

axis equal  % sets the axes so that equal increments on x, y, z-axes are equal in size. Same scale on each axis
%axis off    % turns off all axis labeling, tick marks and background (while keeping the scale settings from above)