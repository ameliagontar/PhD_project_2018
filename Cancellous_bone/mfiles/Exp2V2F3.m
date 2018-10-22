function [NOFmat,ACCmat,lambdavec] = Exp2V2F3

% August 29 2014 (Rostock)
%
% This program is the same as Exp2V2.m except that three feature combinations
% are used in stead of single features as in Exp2V2.m
%
% August 27 2014 (Rostock)
%
% Conduct an experiment in varying the parameter lambda in the merging
% criterion.

% Construct textons using k-means with k = NC
NC = 10;


lambdavec = [.1 .25 .5 .75 1.0 1.3 1.6 2.0 2.5 3.0];
%lambdavec = [ 1 2];
lenLam = length(lambdavec);
NTR = 10;             % number of trials
NOFmat = zeros(NTR,lenLam);
ACCmat = zeros(NTR,lenLam);

load Cohortmat

for kTR = 1:NTR
    
    [TexINIT,GFAINIT] = Textons4Merging(NC);
    
    AccDat = zeros(size(lambdavec));
    %Flamb = zeros(size(lambdavec));
    NTvec = zeros(size(lambdavec));

    for kL = 1:lenLam
        % Merge texton pairs until no two textons meet the mergin criterion  
        % or until the maximum number of mergings has been reached.
        disp(['Iteration    ' int2str(kTR) ' out of ' int2str(NTR)])
        disp(['lambda value ' int2str(kL)  ' out of ' int2str(lenLam)])
    
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
        %accvec = zeros(NT,1);
        for k1 = 1:NT-2
            for k2 = k1+1:NT-1
                for k3 = k2+1:NT
                    Fvec = [k1 k2 k3];
                    [confusmat,acc] = LDAclassify9(Hmat,Cohortmat,Fvec);
                    %accvec(k) = acc;
                    if acc > bestacc
                        bestconfus = confusmat;
                        bestacc = acc;
                        %bestF = [k1 k2];
                    end
                end
            end
        end
    
        %disp(['Confusion matrix for lambda = ' num2str(lambda)])
        %disp(bestconfus)
        %Flamb(kL) = bestF;
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

    
    