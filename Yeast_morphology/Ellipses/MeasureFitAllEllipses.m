function all_MOF = MeasureFitAllEllipses(im,ellipses)

% 5 January 2017
%
% Computes the measure of fit for all ellipses for one image in the data
% set. im is the original image, for example of one yeast colony. ellipses
% is the array of ellipses, where each row is of length 8 and lists the
% centroid, direction vectors and lengths. Foe each of these ellipses, this
% program returns one measure of fit value. 

[no_ellipses,~] = size(ellipses);
all_MOF = zeros(no_ellipses,1);
for k = 1:no_ellipses
    E = ellipses(k,:);
    MOF = MeasureFitOneEllipse(im,E);
    all_MOF(k) = MOF;
end