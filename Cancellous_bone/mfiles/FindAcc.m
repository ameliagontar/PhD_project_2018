function missclass = FindAcc(XTrain,YTrain,XTest,YTest)

%sizeYTestB = size(YTest)
%sizeXTestB = size(XTest)
%sizeXTrainB = size(XTrain)
%sizeYTrainB = size(YTrain)

%disp('YTest')
%disp(YTest)

%disp('XTest')
%disp(XTest)

Classvec = classify(XTest,XTrain,YTrain);

[mc,nc] = size(YTest);

% construct confusion matrix
confusmat = zeros(9,9);
for kk = 1:mc
    truC = YTest(kk);
    algC = Classvec(kk);
    confusmat(truC,algC) = confusmat(truC,algC) + 1;
end
%disp(confusmat)

% compute total error 
totalaccuracy = trace(confusmat);
missclass = 45 - totalaccuracy;



