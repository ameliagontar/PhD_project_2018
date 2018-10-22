function DrawMultipleTextons(feature_array)

% 13 April 2017
%
% Calls the program DrawTexton.m multiple times, in order to draw more than
% one texton at one time, in a plot consisting of multiple subplots.
% feature_array is an array of features/textons, where each row corresponds
% to one texton to be drawn.

[no_features,~] = size(feature_array);
no_rows = ceil(no_features/4);
for f = 1:no_features
    subplot(no_rows,4,f)
    texton = feature_array(f,:);
    DrawTexton(texton)
end