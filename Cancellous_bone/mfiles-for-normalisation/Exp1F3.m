function [bestacc,bestF,bestconfus,accvec] = Exp1F3

% August 16, 2014 (Rostock). Edited by Amelia 14 October 2015.
%
% In this version, all combinations of 3 features are used to search for
% optimal accuracy.
%
% August 12, 2014 (Rostock)
%
% Conduct an experiment
%

% Construct textons using k-means with k = NC
NC = 10;     
tol = 10^(-13);
TextonArray3D = TextonKmeans_local(NC,tol);

% The output array has size NC x NF x 9, where NC is the number of clusters
% per block and NF is the number of features (NF = 13 by default). In order
% to use create texton maps, this has to be rewritten as a 2D array of size
% NC*9 x NF
AllTextons2D = zeros(NC*9,15);
for ka = 1:9
    a = (ka-1)*NC + 1;
    b = ka*NC;
    AllTextons2D(a:b,:) = TextonArray3D(:,:,ka);
end

% Assemble the texton maps and compute normalised histograms of texton
% occurrances for each sub-block for each rat.
Hmat = AllTextonMaps_local(AllTextons2D,tol);

% Test every individual texton for accuracy of classification 
[m90,NT] = size(Hmat);
load Cohortmat

bestacc = 0;

NS = (NT - 2)*(NT - 1)*NT/6;
accvec = zeros(NT,1);
kcnt = 0;
for k1 = 1:NT-2
    for k2 = k1+1:NT-1
        for k3 = k2+1:NT
            kcnt = kcnt + 1;
            Fvec = [k1 k2 k3];
            [confusmat,acc] = LDAclassify9(Hmat,Cohortmat,Fvec);
            accvec(kcnt) = acc;
            if acc > bestacc
                bestconfus = confusmat;
                bestacc = acc;
                bestF = Fvec;
                %LDAdemoF2(Hmat,Cohortmat,Fvec);
            end
        end
    end
end

disp(['The number of combinations is ' int2str(kcnt)])
trC = trace(bestconfus);
disp(['number correct for 9x9 = ' int2str(trC)])
    
    
    
