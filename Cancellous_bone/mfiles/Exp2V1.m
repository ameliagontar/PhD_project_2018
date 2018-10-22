function [bestacc,bestF,bestconfus,accvec] = Exp2V1

% August 27, 2014 (Rostock)
%
% Conduct an initial experiment on classifying the sub-blocks similar to
% Experiment 1 (Exp1.m) but with texton merging included.

% Construct textons using k-means with k = NC
NC = 5;
[TexA,GFA] = Textons4Merging(NC);

% Merge texton pairs until no two textons meet the mergin criterion or 
% until the maximum number of mergings has been reached.
lambda = 4;        % Merging criterion factor: merge c1 and c2 if
                   % |c1 - c2| < lambda*min(sigma_1,sigma_2)
                   
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

% These commands find the mean and variance of the values in H needed to
% construct random versions of H.
Hvec = Hmat(:);
aveH = mean(Hvec)
varH = var(Hvec)

load Cohortmat

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