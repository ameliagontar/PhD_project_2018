function class = FisherDir(g1,g2,test)

% July 10 2001
%
% Compute the unit direction vector determined by the Fisher transform.
%
% Edited by Amelia 5 June 2015. The arguments g1,g2 are the TRAINING rows 
% of texton occurrences. g1 is group 1 and g2 is group 2.
% test is the entire testing set of size n x nf, where n is the number
% of elements in the testing set.
% class is the vector of class assignments for the testing set. 1 meams
% class 1 and 2 means class 2. Need to compare with actual assignments
% later.

g1 = g1';        % now g1 is nfxn1 , nf = no. features
g2 = g2';        % and n1 = no. elements in group 1.
[nf,n1] = size(g1);
[nf,n2] = size(g2);
g1bar = mean(g1')';
g2bar = mean(g2')';
meanmat1 = g1 - g1bar*ones(1,n1);
meanmat2 = g2 - g2bar*ones(1,n2);
S1 = meanmat1*meanmat1';
S2 = meanmat2*meanmat2';
Sp = (S1 + S2)/(n1 + n2 - 2);
Sinv = inv(Sp);    

% Edited by Amelia 16 March 2016.
% We can now get the vector of coefficients of the hyperplane, the vector 
% of coefficients of the linear decision function, or the decision 
% threshold. Comment out what isn't necessary. We need to vary the decision
% threshold for ROC curve analysis.
% This is the vector of coefficients of the hyperplane:
%V = Sinv*(g1bar - g2bar);   
% This is the vector of coefficients of the decision function:
%Vtrans = (g1bar-g2bar)'*Sinv
% This is the decision threshold:
thresh = (1/2)*(g1bar-g2bar)'*Sinv*(g1bar+g2bar);
                            
[n,nf] = size(test);
class = zeros(n,1);     % initialise vector of assignments

k = 0;
for l = 1:n
    k = k+1;
    x = test(k,:);
    x = x';
    LHS = (g1bar-g2bar)'*Sinv*x;
    RHS = (1/2)*(g1bar-g2bar)'*Sinv*(g1bar+g2bar);
    if LHS < RHS
        class(k,:) = 2;
    else
        class(k,:) = 1;
    end
end


