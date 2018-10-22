function [centroid,V1,V2,V3,lgths] = Ellipsoid_conncomp(volume)

% 18 November 2015 (Edited 10 May 2016)
%
% Fits a 3D ellipsoid to a simple binary volume. This program should be 
% used in cases where the binary volume is one connected component only.  
%
% volume is the input binary volume with one connected component. centroid 
% is the centroid of the ellipsoid, V1 is the row direction vector of the 
% major axis, V2 is the row direction vector of the middle axis, V3 is the 
% row direction vector of the minor axis, and lgths is the row vector of 
% respective axis lengths.

idx = find(volume);
[a,b,c] = size(volume);
[y,x,z] = ind2sub([a,b,c],idx);
centroid = [mean(x),mean(y),mean(z)];
xc = x - mean(x);           % centralised x coordinates
yc = y - mean(y);           % centralised y coordinates
zc = z - mean(z);           % centralised z coordinates      
X = [xc yc zc];             % array of centralised coordinates
M = (X')*X;                 % variance matrix
[V,D] = eig(M);             % V are eigenvectors of M.
lambda1 = abs(D(1,1));      % eigenvalues of M.
lambda2 = abs(D(2,2));
lambda3 = abs(D(3,3));

% Normalise the eigenvalues:
omega_vol = sum(sum(sum(volume)));
l = ((3*omega_vol)/(4*pi*sqrt(lambda1*lambda2*lambda3)))^(2/3);
n1 = sqrt(l*lambda1);
n2 = sqrt(l*lambda2);
n3 = sqrt(l*lambda3);
eigvals = [n1,n2,n3];

% Sort into major, middle and minor axes:
[lgths,idx] = sort(eigvals,'descend');
V1 = V(:,idx(1));
V1 = V1';
V2 = V(:,idx(2));
V2 = V2';
V3 = V(:,idx(3));
V3 = V3';