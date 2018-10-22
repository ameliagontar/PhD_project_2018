function Exp5V3

% November 12, 2014 (Rostock)
%
% Run sequential feature selection on oriented thickness feature and
% standard bone structure attributes.

% Construct textons using k-means with k = NC
NC = 10;
TextonArray3D = TextonKmeans(NC);

% The output array has size NC x NF x 9, where NC is the number of clusters
% per block and NF is the number of features (NF = 13 by default). In order
% to use create texton maps, this has to be rewritten as a 2D array of size
% NC*9 x NF
AllTextons2D = zeros(NC*9,13);
for ka = 1:9
    a = (ka-1)*NC + 1;
    b = ka*NC;
    AllTextons2D(a:b,:) = TextonArray3D(:,:,ka);
end

% Assemble the texton maps and compute normalised histograms of texton
% occurrances for each sub-block for each rat.
Hmat = AllTextonMaps(AllTextons2D);
load StandardAttributes
Hmat = [StandardAttributes(:,3:8) Hmat];

% Test every individual texton for accuracy of classification 
[m90,NT] = size(Hmat);
load Cohortmat

XTrain = zeros(45,NT);
YTrain = zeros(45,1);
Ratvec = zeros(size(YTrain));
bcnt = 0;
% construct the truth vector YTrain for class assignment
% and the training set Xtrain from Hmat
for kG = 1:3  % for each of the 3 experimental groups: sham, ovx, zol
    curcol = (kG - 1)*2 + 1;
    for kR = 1:5 % for each of the 5 rats in the group
        ratid = Cohortmat(kR,curcol);
        a = (ratid - 1)*3 + 1;
        bcnt = bcnt + 1;
        b = (bcnt - 1)*3 + 1;
        XTrain(b:b+2,:) = Hmat(a:a+2,:);
        YTrain(b:b+2) = (kG - 1)*3 + [1 2 3]; 
        Ratvec(b:b+2) = ratid*ones(3,1);
    end
end

XTest = zeros(45,NT);
YTest = zeros(45,1);
Ratvec = zeros(size(YTest));
bcnt = 0;
% construct the truth vector YTest for class assignment
% and the training set Xtest from Hmat
for kG = 1:3  % for each of the 3 experimental groups: sham, ovx, zol
    curcol = kG*2;
    for kR = 1:5 % for each of the 5 rats in the group
        ratid = Cohortmat(kR,curcol);
        a = (ratid - 1)*3 + 1;
        bcnt = bcnt + 1;
        b = (bcnt - 1)*3 + 1;
        XTest(b:b+2,:) = Hmat(a:a+2,:);
        YTest(b:b+2) = (kG - 1)*3 + [1 2 3]; 
        Ratvec(b:b+2) = ratid*ones(3,1);
    end
end

InModel = sequentialfs(@FindAcc,XTrain,YTrain);
BestFeatVec = find(InModel > 0)



% Now find the classification with these feature on the testing set.
XTestBest = XTest(:,BestFeatVec);
XTrainBest = XTrain(:,BestFeatVec);
%YTestBest = YTest(:,BestFeatVec);
%YTrainBest = YTrain(:,BestFeatVec);

Classvec = classify(XTestBest,XTrainBest,YTrain);

[mc,nc] = size(YTest);

% construct confusion matrix
confusmat = zeros(9,9);
for kk = 1:mc
    truC = YTest(kk);
    algC = Classvec(kk);
    confusmat(truC,algC) = confusmat(truC,algC) + 1;
end
%disp(confusmat)

% compute accuracy
totalaccuracy = trace(confusmat)/45

