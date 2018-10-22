function [bestacc,bestF,bestconfus,Saccmat] = Exp5V2

% November 10, 2014 (Rostock)
%
% This program is based on Exp1V3.m but lists results for the best 
% feautures selected from all texton features plus 6 standard structure
% features. 

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

bestacc = 0;

NS = (NT - 2)*(NT - 1)*NT/6
accmat = zeros(NT,4);
kcnt = 0;
for k1 = 1:NT-2
    for k2 = k1+1:NT-1
        for k3 = k2+1:NT
            kcnt = kcnt + 1;
            Fvec = [k1 k2 k3];
            [confusmat,acc] = LDAclassify9(Hmat,Cohortmat,Fvec);
            accmat(kcnt,:) = [acc k1 k2 k3];
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
% Sort the output matrix in descending order of accuracy.
Avec = accmat(:,1);
[SortAvec,ivec] = sort(Avec,'descend');
%sizeSortAvec = size(SortAvec);
%sizeivec = size(ivec);
Saccmat = accmat(ivec,1:4);

    
    
    
