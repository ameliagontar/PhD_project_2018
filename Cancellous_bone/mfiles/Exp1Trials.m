function [cpvec,cavec] = Exp1Trials

% 23 April 2015
%
% The aim is to run the program Exp1.m N times, and produce a vector
% of the number of correct assignments for skeletonised rat blocks (9x9),
% of length N; then find the mean and std of no. of correct assignments.
% Effectively a copy of Exp1SkelTrials.m. Fairly long run time.

hdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles'];

cd(hdir)

N = 100;    % choose number of trials
cpvec = zeros(N,1);   % make a blank vector ("correct proportion" vector)

for k = 0:N-1
    k = k+1;
    try                     % program doesn't terminate if Exp1 fails once
    bestacc_k = Exp1;
    catch
        bestacc_k = Exp1;
    end
    cpvec(k,1) = bestacc_k;
end

T = 45;     % number of rats in testing set
cavec = cpvec.*T;   % convert proportion correct to absolute number correct
                    % ("correct assignment" vector)
    