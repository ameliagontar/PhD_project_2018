function [cpvec,cavec] = Exp1F3Skel1Trials

% 29 April 2015
%
% The aim is to run the program Exp1F3Skel1.m N times, and produce a vector
% of the number of correct assignments for skeletonised rat blocks (9x9),
% of length N; then find the mean and std of no. of correct assignments.
% Effectively a copy of Exp1SkelTrials1.m

hdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/my-mfiles'];

cd(hdir)

N = 10;    % choose number of trials. Seems to fail (despite try and catch
           % loops) for N = 100. Could try N = 50?
cpvec = zeros(N,1);   % make a blank vector ("correct proportion" vector)

for k = 0:N-1
    k = k+1;
    try
    bestacc_k = Exp1F3Skel1;
    catch
        try                         % needs a few more try and catch loops
            bestacc_k = Exp1F3Skel1; % because Exp1F3Skel seems to fail more 
        catch                       % often than one or two features
            bestacc_k = Exp1F3Skel1;
            try
            bestacc_k = Exp1F3Skel1;
        catch
            bestacc_k = Exp1F3Skel1;
             try
            bestacc_k = Exp1F3Skel1;
             catch
                 bestacc_k = Exp1F3Skel1;
                 try
            bestacc_k = Exp1F3Skel1;
            catch
            bestacc_k = Exp1F3Skel1;
                 end
                 bestacc_k = Exp1F3Skel1;
             end
             bestacc_k = Exp1F3Skel1;
            end
        bestacc_k = Exp1F3Skel1;
        end
        bestacc_k = Exp1F3Skel1;
    end
    cpvec(k,1) = bestacc_k;
end

T = 45;     % number of rats in testing set
cavec = cpvec.*T;   % convert proportion correct to absolute number correct
                    % ("correct assignment" vector)
    