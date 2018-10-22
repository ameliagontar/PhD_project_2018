function [C,V1,V2,lgths] = FitEllipseConnComp(cc)

% 6 September 2016
%
% A function that fits an ellipse to one binary connected component cc
% using principal component analysis. Assumes cc is one connected component
% only, do not use for general ellipse fitting. Based on Murk's program 
% EllipseFit from 30 August 2015.
%
% C is the centroid of the ellipse, V1 is the normalised direction vector 
% in the major direction, V2 is the normalise direction vector in the minor
% direction, and lgths are the lengths of the semi-major and semi-minor
% axes, respectively.

[y,x] = find(cc);
meanx = mean(x);      % mean of x coordinates
meany = mean(y);      % mean of y coordinates
C = [meanx,meany];    % centroid
xc = x - meanx;       % centralised x coordinates
yc = y - meany;       % centralised y coordinates
xx = [xc yc];         % array of centralised coordinates
CV = (xx')*xx;        % variance matrix
[V,D] = eig(CV);      % D is the diagonal array of singular values of CV
lam1 = abs(D(1,1));   % lam1 and lam2 are the eigenvalues of CV
lam2 = abs(D(2,2));

% Normalise the eigenvalues to get lengths of the semi-axes:
Acc = sum(sum(cc));
l = sqrt(Acc/(pi*lam1*lam2));
L1 = l*lam1;
L2 = l*lam2;
evals = [L1,L2];

% Sort the normalised eigenvalues (semi-major axis first, semi-minor axis
% second):
[lgths,idx] = sort(evals,'descend');
V1 = V(:,idx(1));
V1 = V1';
V2 = V(:,idx(2));
V2 = V2';


