function DrawTexton(texton)

% 24 February 2017
%
% A program that draws one oriented thickness texton, for visualisation.
% texton is a vector of values, corresponding to the value of the texton.
% The midpoint of each thickness measurement is positioned at the origin,
% with the thickness measurements in each direction (at each angle) being
% represented by the length of the line passing through the origin in that
% direction.

d = length(texton);
%figure;
hold on
for k = 1:d
    theta = (k-1)*(pi/d);
    L = texton(k)/2;
    xstart = (-1)*L*cos(theta);
    ystart = (-1)*L*sin(theta);
    xend = L*cos(theta);
    yend = L*sin(theta);
    X = [xstart,xend];
    Y = [ystart,yend];
    plot(X,Y,'b')
end
hold off
    