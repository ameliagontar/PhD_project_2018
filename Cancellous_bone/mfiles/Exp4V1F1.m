function [NOFmat,ACCmat] = Exp4V1F1

% October 2 2014 (Rostock)
%
% This program is adapted from Exp2V2.m for conducting Group 3 experiments
% (but with filenames referring erroneously to experiment 2) on applying
% mergin after clustering. This version uses azimuth free feature vectors
% of length 13 stored in the directory .../Combined13
%
% August 27 2014 (Rostock)
%
% Conduct an experiment in varying the parameter lambda in the merging
% criterion. In this experiment, 90 features (10 per class) are merged
% according to parameter lambda for various choice of lambda. The best
% single feature is then used for classificaiton.

% Construct textons using k-means with k = NC
NC = 10;


lambdavec = [.1 .25 .5 .75 1.0 1.3 1.6 2.0 2.5 3.0 3.5 4]
lenLam = length(lambdavec);
NTR = 10;             % number of trials
NOFmat = zeros(NTR,lenLam);
ACCmat = zeros(NTR,lenLam);

load Cohortmat

for kTR = 1:NTR
    
    [TexINIT,GFAINIT] = Textons4MergingExp4(NC);
    
    AccDat = zeros(size(lambdavec));
    Flamb = zeros(size(lambdavec));
    NTvec = zeros(size(lambdavec));

    for kL = 1:lenLam
        % Merge texton pairs until no two textons meet the mergin criterion  
        % or until the maximum number of mergings has been reached.
    
        GFA = GFAINIT;
        lambda = lambdavec(kL);
        TexA = TexINIT;
        [NT,m13] = size(TexA);
        disp(['Number of initial texons = ' int2str(NT)])
        Mflag = 1;
        Mcnt = 0;
        MaxMerge = 100;      % maximum number of mergings.
        tic
        while Mflag == 1
            [GFA,TexA] = MergeTextons(GFA,TexA,lambda);
            [NTcur,m13] = size(TexA);
            if NTcur == NT
                Mflag = 0;
            end
            NT = NTcur;
            Mcnt = Mcnt + 1;
            if Mcnt == MaxMerge
                Mflag = 0;
            end
        end

        disp(['Number of final textons = ' int2str(NT)])
        disp(['Time for merging'])
        toc
        disp(['Final textons'])
        disp(TexA)

        % Assemble the texton maps and compute normalised histograms of 
        % texton occurrances for each sub-block for each rat.
        Hmat = AllTextonMaps(TexA);

        % Test every individual texton for accuracy of classification 
        [m90,NT] = size(Hmat);

        bestacc = 0;
        accvec = zeros(NT,1);
        for k = 1:NT
            Fvec = k;
            [confusmat,acc] = LDAclassify9(Hmat,Cohortmat,Fvec);
            accvec(k) = acc;
            if acc > bestacc
                bestconfus = confusmat;
                bestacc = acc;
                bestF = k;
            end
        end
    
        %disp(['Confusion matrix for lambda = ' num2str(lambda)])
        %disp(bestconfus)
        Flamb(kL) = bestF;
        AccDat(kL) = bestacc;
        NTvec(kL) = NT;
    end

    %disp(['lambda   ' num2str(lambdavec)])
    %disp(['number of textons ' int2str(NTvec)])
    %disp(['accuracy ' num2str(AccDat)])
    %disp(['Best feature ' int2str(Flamb)])

    nummat = [lambdavec;NTvec;AccDat];
    txtmat = [
        'lambda             ';
        'number of textons  ';
        'accuracy           '];
    displaymat = [txtmat  num2str(nummat)];
    disp(displaymat)
    
    NOFmat(kTR,1:lenLam) = NTvec;
    ACCmat(kTR,1:lenLam) = AccDat;
    
end

disp(['lambda values ' num2str(lambdavec)])
disp(['number of features '])
disp(NOFmat)
disp(' ')
disp(['accuracies '])
disp(ACCmat)

meanNOF = mean(NOFmat);
meanACC = mean(ACCmat);
stdNOF = std(NOFmat);
stdACC = std(ACCmat);
disp([' mean number of features ' num2str(meanNOF)])
disp(['  std number of features ' num2str(stdNOF)])
disp([' mean accuracy ' num2str(meanACC)])
disp(['  std accuracy ' num2str(stdACC)])

    
    