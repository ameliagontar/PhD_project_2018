function [cpvec,cavec] = Exp1Skel1Trials

% 23 April 2015
%
% The aim is to run the program Exp1Skel1.m N times, and produce a vector
% of the number of correct assignments for skeletonised rat blocks (9x9),
% of length N; then find the mean and std of no. of correct assignments.

hdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/my-mfiles'];

cd(hdir)

N = 100;    % choose number of trials
cpvec = zeros(N,1);   % make a blank vector ("correct proportion" vector)

for k = 0:N-1
    k = k+1;
    try                     % program doesn't terminate if Exp1Skel fails once
    bestacc_k = Exp1Skel1;
    catch
        try
           bestacc_k = Exp1Skel1;
        catch
            bestacc_k = Exp1Skel1;
        end
        bestacc_k = Exp1Skel1;
    end
    cpvec(k,1) = bestacc_k;
end

T = 45;     % number of rats in testing set
cavec = cpvec.*T;   % convert proportion correct to absolute number correct
                    % ("correct assignment" vector)
                    

    