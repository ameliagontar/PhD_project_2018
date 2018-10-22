function testThicknessFeatures4or13

% July 22, 2014 (Rostock)
%
% Test the program ThicknessFeatures4or13.m

B = ones(3,3,3);
maxk = 5;
ssf = 1;
thetamat = ThicknessFeatures4or13(B,maxk,13,ssf);



cd ~/Dropbox/Adir/Research/Groups/BoneGroup/remodelling/RatData400/BreeRatData
load rat02w08.mat
cd ~/Dropbox/Adir/Research/Groups/BoneGroup/remodelling/Textons3D/mfiles/

maxk = 50;
M = 13;
ssf = .01;

s = rng;
tic
thetamat = ThicknessFeatures4or13(x,maxk,13,ssf);
toc


% construct a 2D histogram of the results.
maxT = ceil(max(max(thetamat)))
bins = 4:7:maxT;
Nbins = length(bins);
HH = zeros(Nbins,13);

for Th = 1:13
    curc = thetamat(:,Th);
    h = hist(curc,bins);
    HH(:,Th) = h;
end

disp('histogram for 13 directions')
disp(HH)

figure(1)
imagesc(HH)
title('13 orientations')
disp('thetamat for 13 directions')
disp(thetamat(1:20,:));

[a,b] = size(thetamat);

% Combine the orientations to produce four orientations
    tempmat = zeros(a,4);
    t1 = (max(thetamat(:,1:4)'))';
    tempmat(:,1) = t1;
    t2 = (max(thetamat(:,5:8)'))';
    tempmat(:,2) = t2;
    t3 = (max(thetamat(:,9:12)'))';
    tempmat(:,3) = t3;
    tempmat(:,4) = thetamat(:,13);
    thetamat = tempmat;

    
disp(' ')
disp('thetamat for 4 directions')
disp(thetamat(1:20,:))
return

H4 = zeros(Nbins,4);
for Th = 1:4
    curc = thetamat(:,Th);
    h = hist(curc,bins);
    H4(:,Th) = h;
end

%disp(H4)

%figure(2)
%imagesc(H4)
%title('4 orientations')
