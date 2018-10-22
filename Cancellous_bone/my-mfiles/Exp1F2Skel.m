function [bestacc,bestF,bestconfus,accvec] = Exp1F2Skel

% August 15, 2014 (Rostock)
%
% In this version, all combinations of 2 features are used to search for
% optimal accuracy.
%
% August 12, 2014 (Rostock)
%
% Conduct an experiment
%

% Construct textons using k-means with k = NC
NC = 5;
TextonArray3D = TextonKmeansSkel(NC);

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
Hmat = AllTextonMapsSkel(AllTextons2D);

% Test every individual texton for accuracy of classification 
[m90,NT] = size(Hmat);
load Cohortmat

bestacc = 0;

NS = (NT - 1)*NT/2
accvec = zeros(NT,1);
kcnt = 0;
for k1 = 1:NT-1
    for k2 = k1+1:NT;
        kcnt = kcnt + 1;
        Fvec = [k1 k2];
        [confusmat,acc] = LDAclassify9skel(Hmat,Cohortmat,Fvec);
        accvec(kcnt) = acc;
        if acc > bestacc
            bestconfus = confusmat;
            bestacc = acc;
            bestF = Fvec;
            %LDAdemoF2(Hmat,Cohortmat,Fvec);
        end
    end
end

disp(['The number of combinations is ' int2str(kcnt)])

trC = trace(bestconfus);
disp(['number correct for 9x9 = ' int2str(trC)])
v1 = sum(sum(bestconfus(1:3,1:3)));
v2 = sum(sum(bestconfus(4:6,4:6)));
v3 = sum(sum(bestconfus(7:9,7:9)));
vv = v1 + v2 +v3;
disp(['number correct for 3x3 = ' int2str(vv)])

    
    
