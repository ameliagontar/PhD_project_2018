function w = DensityPlot(myblock)

% 17 March 2015
% Aim to write a program which chooses one block (400 slices) and
% calculates the total number of on voxels in each slice. This
% gives an estimation of bone density. Then plot density for each slice
% to see how density varies from one end of the block to another.
% Uses Murk's AllRats13Features.m as an example (originally, but then
% simplified a lot!)

% In the 'function' part above, we can specify an output (w) and an
% argument (myblock). Myblock refers to all the recurring instances of
% myblock in the code. We now need to change our directory and load our
% data block A in the command window. Then we type in DensityPlot(A) and
% the code does everything for our chosen block :) 

% The output will just be the maximum density. We can specify this in our
% program, as below.
                                     
%xvec = .0087*(1:400);   % normalises pixels to mm
xvec = 1:100;
density = squeeze(sum(sum(myblock)));   % sum sum gives an array of size 400 x 1 x 1. Squeeze compresses this into 400 x 1
plot(xvec,density)
w = max(density);