function Exp2V2

% August 27 2014 (Rostock)
%
% Conduct an experiment in varying the parameter lambda in the merging
% criterion.

% Construct textons using k-means with k = NC
NC = 5;
[TexINIT,GFA] = Textons4Merging(NC);

Lambdavec = [.5 1.0 2.0 4.0];
lenLam = length(labmdavec);
AccDat = zeros(size(lambdavec));
Flamb = zeros(size(lambdavec));

load Cohortmat

for kL = 1:lenLam
    % Merge texton pairs until no two textons meet the mergin criterion or 
    % until the maximum number of mergings has been reached.
    
    TexA = TexINIT;
    [NT,m13] = size(TexA);
    disp(['Number of initial texons = ' int2str(NT)])
    Mflag = 1;
    Mcnt = 0;
    MaxMerge = 50;      % maximum number of mergings.
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

    % Assemble the texton maps and compute normalised histograms of texton
    % occurrances for each sub-block for each rat.
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
    
    disp(['Confusion matrix for lambda = ' num2str(lambda)])
    disp(bestconfus)
    Flamb(kL) = bestF;
    AccDat(kL) = bestacc;
end

disp(['lambda   ' num2str(lambdavec)])
disp(['accuracy ' num2str(AccDat)])
disp(['Best feature ' int2str(Flamb)])

    
    