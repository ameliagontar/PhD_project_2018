function MarbProportions = GetProportions(MarbSteakVols)

% 23 January 2017
%
% Computes the marbling proportion for each cow 1-20 from the array 
% MarbSteakVols.mat. This array contains the volume of marbling for each
% cow in column 1 and the total volume of the steak in column 2. Each row
% represents one cow.

[no_cows,~] = size(MarbSteakVols);
MarbProportions = zeros(no_cows,1);
for k = 1:no_cows
    mp = MarbSteakVols(k,1)/MarbSteakVols(k,2);
    MarbProportions(k) = mp;
end