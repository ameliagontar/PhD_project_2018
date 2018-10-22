function RatBoneThickness

% July 21, 2014 (Rostock)
%
% Compute thickness attributes for three rats, one from each group.

cd ~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/RatData/
load rat02w08.mat
cd ~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles/

maxk = 50;  % maximum length parameter
tic
thetamat = ThicknessFeatures(x,maxk);
toc

disp(thetamat(1:30,:))
%size(thetamat)

% construct a 2D histogram of the results.
maxT = ceil(max(max(thetamat)))
bins = 4:7:maxT
Nbins = length(bins);
HH = zeros(Nbins,13);

for Th = 1:13
    curc = thetamat(:,Th);
    h = hist(curc,bins);
    HH(:,Th) = h;
end

disp(HH)

imagesc(HH)

% combine oirentations makeing the same angle with the bone axis. Report
% the proportion of line segments for various directions.




    
    

