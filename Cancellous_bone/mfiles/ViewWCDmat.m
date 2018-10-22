function ViewWCDmat(NTvec,WCDmat)

% August 18, 2014 (Rostock)
%
% Analyse and display contents of the file WCDmat.mat. This array was
% produced by NumberOfTextons.m and lists for each sub-block for each
% experimental group, the total within cluster distances as these depend on
% the number of clusters. In addtion, there total with cluster distances
% for equivalent random data.

%load WCDmat

%NTvec = [2 3 4 6 8 10W];
%NTvec = [1 7 14 21 28 35]
NS = length(NTvec);
BestNT = zeros(9,1);

for k = 1:9
    subplot(3,3,k)
    Dk = 2*(k-1) + 1;
    Rk = 2*k;
    logN = log(WCDmat(Dk,1));
    logD = log(WCDmat(Dk,:))/logN;
    logR = log(WCDmat(Rk,:))/logN;
    plot(NTvec,logD,'b')
    hold on
    plot(NTvec,logR,'r')
    hold off
    diffvec = logR - logD;
    [maxd,NTopt] = max(diffvec);
    %text(.7*NTvec(NS),.7,['Opt = ' int2str(NTopt)])
    miny = min(min(logD),min(logR));
    axis([NTvec(1) NTvec(NS) miny 1])
    BestNT(k) = NTvec(NTopt);
end

BestNT = reshape(BestNT,3,3);
BestNT = BestNT';
disp(BestNT)

    
    