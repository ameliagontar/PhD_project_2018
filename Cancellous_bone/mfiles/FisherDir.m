function vec = FisherDir(g1,g2)

% July 10 2001
%
% Compute the unit direction vector determined
% by the Fisher transform.

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
vec = Sinv*(g1bar - g2bar);
