function acc = ClassifyOneFeature

% 21 October 2015
%
% A program that generates a column vector of length 90, where each row
% corresponds to the density of each sub-block (30 rats x 3 sub-blocks
% each), and then performs a LDA classification based on this one feature
% only.

sdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/RatData'];
hdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles-for-normalisation'];

Hmat = zeros(90,1);
avec = [1 101 201];
L = 99;

k = 0;
for kR = 1:30
    for kB = 1:3
        k = k+1;
        if kR < 10
            ratdata = ['rat0' int2str(kR) 'w08'];
        else
            ratdata = ['rat' int2str(kR) 'w08'];
        end
        
        cd(sdir)
        eval(['load ' ratdata])
        cd(hdir)
        
        a = avec(kB);
        curB = x(:,:,a:a+L);
        vol_bone = sum(sum(sum(curB)));
        [R C P] = size(curB);
        vol_block = R*C*P;
        D = vol_bone/vol_block;
        Hmat(k) = D;
    end
end

load Cohortmat
[confusmat,acc] = LDAclassify9(Hmat,Cohortmat,1);