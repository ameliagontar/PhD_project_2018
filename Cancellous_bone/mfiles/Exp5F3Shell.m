function [topfeatmat,topconfus] = Exp5F3Shell

% November 11, 2014 (Rostock)
%
% The program forms a shell to run Exp5V2.m many time in order to
% understand typical and average results.

N = 12;
topacc = 0;
topfeatmat = zeros(N,4);
for k = 1:10
    [bestacc,bestF,bestconfus,Saccmat] = Exp5V2;
    topfeatmat(k,:) = Saccmat(1,:);
    if bestacc > topacc
        topacc = bestacc;
        topconfus = bestconfus;
    end
end


        