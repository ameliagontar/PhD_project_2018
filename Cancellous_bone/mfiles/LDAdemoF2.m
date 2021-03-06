function LDAdemoF2(Hmat,Cohortmat,Fvec)

% August 15 2014 (Rostock)
%
% The is a version of the program LDAclassify9.m to use for constructing
% pictures to illustrate the classification process in the case of 2
% features.
%
% August 14 2014 (Rostock)  [this program has not be validated]
%
% A program for classifying 9 sub-blocks, producing a confusion matrix
% and computing the accuracy. The imput of the program is Hmat generated by
% AllTextonsMaps.m and Cohortmat.
%
% Hmat is the array of histograms. Hmat is of size 90 x NT. Each row of
% Hmat lists the normalized histogram values for the block associated with
% the perticular row.
%
% The ordering of the rows is
% row 1 = rat 1, block 1; row 2 = rat 1, block 2; row 3 = rat 1, block 3;
% row 4 = rat 2, block 1; row 5 = rat 2, block 2; row 6 = rat 2, block 3;%
% etc.
%
% The program loads Cohortmat. This is an array of size 5 x 6 and lists the
% membership of all rats to training and testing sets as follows. 
% column 1 = sham training rats       column 2 = sham testing rats
% column 3 = ovx training rats        column 4 = ovx testing rat
% column 5 = ovx+zol training rats    column 6 = ovx+zol testing rats
%
% Fvec is the vector of features indices used for classification 

NF = length(Fvec); % number of features used for classifation

% Determine the number of textons, NT, from the input array Hmat
[m90,NT] = size(Hmat);

Trainset = zeros(45,NF);    % initialize Training set
Samplset = zeros(45,NF);    % initialize Testing set (Sample)
Grpvec = zeros(45,1);       % initialize group assignments for training
Ncnt = 0;             % counter for training cases
Scnt = 0;             % counter for testing (sample) cases
for kg = 1:3          % kg counts experimental groups: sham, ovx, zol

    for kr = 1:5      % kr counts rats in the group
        Nid = Cohortmat(kr,kg*2 - 1);  % id of rat kr in training group kg
        Sid = Cohortmat(kr,kg*2);      % id of rat kr in sample group kg
        for kb = 1:3  % kb counts sub-blocks
            Htranrow = 3*(Nid - 1) + kb;
            Htestrow = 3*(Sid - 1) + kb;
            Ncnt = Ncnt + 1;
            Scnt = Scnt + 1;
            Trainset(Ncnt,:) = Hmat(Htranrow,Fvec);
            Samplset(Scnt,:) = Hmat(Htestrow,Fvec);
            TGrpvec(Ncnt) = 3*(kg - 1) + kb;
            SGrpvec(Scnt) = 3*(kg - 1) + kb;
        end
    end
end

cmat = [
    1 0 0;
    0 1 0;
    0 0 1;
    1 1 0;
    1 0 1;
    0 1 1;
    0 0 0;
    .5 1 0;
    1 .5 0];
    
    
maxd = max(max(max(Trainset)),max(max(Samplset)));


figure
for k = 1:9
    subplot(3,3,k)
    plot(Trainset(:,1),Trainset(:,2),'b.')
    hold on
    a = 5*(k - 1) + 1;
    b = 5*k;
    f1 = Trainset(a:b,1);
    f2 = Trainset(a:b,2);
    plot(f1,f2,'r+')
    hold on
    axis([0 maxd 0 maxd])
    hold off
    set(gca,'xtick',[ ],'ytick',[ ])
end

figure
for k = 1:9
    subplot(3,3,k)
    plot(Samplset(:,1),Samplset(:,2),'b.')
    hold on
    a = 5*(k - 1) + 1;
    b = 5*k;
    f1 = Samplset(a:b,1);
    f2 = Samplset(a:b,2);
    plot(f1,f2,'r+')
    hold on
    axis([0 maxd 0 maxd])
    hold off
    set(gca,'xtick',[ ],'ytick',[ ])
end




