function phi = GetAngle(x_mean,y_mean,x_eg,y_eg)

% 11 August 2016
%
% Calculates the angle phi, in radians, that the line joining the centre of
% a yeast sample to an example point makes with the x axis. x_mean and
% y_mean are the coordinates of the centre, and x_eg and y_eg are the
% coordinates of the example point. In practice, the example point will
% usually be a boundary point, at which we will compute textons later.

% Find the length of the line joining the two points:
L = sqrt((x_mean-x_eg).^2+(y_mean-y_eg).^2);

% Establish whether the line is in Q1&2 or Q3&4:
H = y_eg-y_mean;

% Calculate the angle:
if H >= 0
    phi = acos((x_eg-x_mean)/L);
else
    phi = 2*pi-acos((x_eg-x_mean)/L);
end