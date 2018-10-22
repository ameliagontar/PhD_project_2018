function cpvec = Exp1F3_random_trials(NC,M)

% 14 April 2016
%
% A function that conducts M trials of Experiment 1 with three features.
% M is the number of times that the block labels are randomised. One trial
% is conducted for each instance of the randomisation. NC is the number of 
% textons per class. cpvec is the vector of correct proportions for each
% randomised experiment.

cpvec = zeros(M,1);
for m = 1:M
    RandomiseFeatureArrays;
    [bestacc,~,~,~] = Exp1F3_random(NC);
    cpvec(m) = bestacc;
end