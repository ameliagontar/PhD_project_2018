function Exp1F2_rand

% August 16, 2014 (Rostock)
%
% Adaptation of Exp1_rand.m and Exp1F2.m to repeat Exp1F2.m with random
% data
%
% August 15, 2014 (Rostock)
%
% Conduct an experiment similar to Exp1.m but using random data to
% determine the expected accuracy and the variation
%

% Construct textons using k-means with k = NC
NC = 5;
%TextonArray3D = TextonKmeans(NC);

% The output array has size NC x NF x 9, where NC is the number of clusters
% per block and NF is the number of features (NF = 13 by default). In order
% to use create texton maps, this has to be rewritten as a 2D array of size
% NC*9 x NF
%AllTextons2D = zeros(NC*9,13);
%for ka = 1:9
%    a = (ka-1)*NC + 1;
%    b = ka*NC;
%    AllTextons2D(a:b,:) = TextonArray3D(:,:,ka);
%end

% Assemble the texton maps and compute normalised histograms of texton
% occurrances for each sub-block for each rat.
% Hmat = AllTextonMaps(AllTextons2D);

% Test every individual texton for accuracy of classification 
%[m90,NT] = size(Hmat);
NT = 9*NC;

% parameters for setting random values in Hmat according to a gamma
% distribution having the same mean and variance as Hmat found by Exp1.m
aveH = 219;     % mean of values in Hmat before normalization
varH = 64412;   % variance of values in Hmat before normalization
A = (aveH^2)/varH;
B = varH/aveH;

load Cohortmat


Nos = 1000;     % number of random trials
BestAccVec9 = zeros(Nos,1);
BestFeaVec9 = zeros(Nos,2);
BestAccVec3 = zeros(Nos,1);
BestFeaVec3 = zeros(Nos,2);
for kI = 1:Nos
    Hmat = gamrnd(A,B,90,NT);
    %Hmat = randn(90,NT);
    sumH = (sum(Hmat'))';
    sumHA = sumH*ones(1,NT);
    Hmat = Hmat./sumHA;

    bestacc9 = 0;
    bestacc3 = 0;
    
    NS = (NT - 1)*NT/2;
    accvec = zeros(NT,1);
    kcnt = 0;
    for k1 = 1:NT-1
        for k2 = k1+1:NT;
            kcnt = kcnt + 1;
            Fvec = [k1 k2];
            [confusmat,acc] = LDAclassify9(Hmat,Cohortmat,Fvec);
            %accvec(k) = acc;
        
            % compute proportion accuracy for 3 x 3 experimental group matrix
            v1 = sum(sum(confusmat(1:3,1:3)));
            v2 = sum(sum(confusmat(4:6,4:6)));
            v3 = sum(sum(confusmat(7:9,7:9)));
            acc3 = (v1 + v2 + v3)/45;
        
            if acc > bestacc9
                %bestconfus9 = confusmat;
                bestacc9 = acc;
                bestF9 = Fvec;   
            end
        
            if acc3 > bestacc3
                %bestconfus3 = confusmat;
                bestacc3 = acc3;
                bestF3 = Fvec;
            end
        end
    end
    
    BestAccVec9(kI) = bestacc9;
    BestFeaVec9(kI,:) = bestF9;
    BestAccVec3(kI) = bestacc3;
    BestFeaVec3(kI,:) = bestF3;
    
end

disp(' ')
disp(['The number of samples, n = ' int2str(Nos)])
disp(' ')
disp('For the full 9 x 9 confusion matrix for sub-blocks')
disp(['mean = ' num2str(mean(BestAccVec9))])
disp(['std = ' num2str(std(BestAccVec9))])
disp(['min = ' num2str(min(BestAccVec9))])
disp(['max = ' num2str(max(BestAccVec9))])
disp(['median = ' num2str(median(BestAccVec9))])

disp(' ')
disp('For the 3 x 3 confusion matrix for experimental groups')
disp(['mean = ' num2str(mean(BestAccVec3))])
disp(['std = ' num2str(std(BestAccVec3))])
disp(['min = ' num2str(min(BestAccVec3))])
disp(['max = ' num2str(max(BestAccVec3))])
disp(['median = ' num2str(median(BestAccVec3))])
    
    
    
