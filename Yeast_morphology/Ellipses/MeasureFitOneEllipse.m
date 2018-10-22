function MOF = MeasureFitOneEllipse(im,E)

% 5 January 2017
%
% A function that draws one ellipse using meshgrid, then calculates its
% measure of fit. E is a vector of length eight, with the first two 
% elements being the centroid of the ellipse. Elements 3--4 correspond to 
% the unit eigenvector giving the direction of the major axis, elements 
% 5--6 correspond to the direction of the minor axis, and elements 7--8 are
% the lengths of the semi-major and semi-minor axes, respectively. im is 
% the original image that the ellipse has been fit to and is used to
% calculate the areas needed to get the measure of fit.
% 
% Let A be the area of the ellipse. Let B be the area inside the ellipsoid
% and outside the colony. Then, MOF is the measure of fit and is defined by
% MOF = 1-B/A.

[draw_ell,im_pad] = DrawOneEllipse(im,E);
A = sum(sum(draw_ell));
add_draw = 2*draw_ell+im_pad;
intersection = (add_draw == 2);
intersection = double(intersection);
B = sum(sum(intersection));
MOF = 1-B/A;