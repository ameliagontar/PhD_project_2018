function Ellipsoid_draw(vol,C,V,lgths)

% 11 May 2016
%
% Takes the parameters describing an ellipsoid (centroid, eigenvectors,
% normalised eigenvalues) and displays the ellipsoid using vol3d.m. C is
% the centroid of the ellipsoid, 1x3 vector, V is the matrix of
% eigenvectors as column vectors, 3x3 matrix, and lgths is a 1x3 vector
% with the lengths of the major, middle and minor axes. 
%
% This program constructs a meshgrid to draw the ellipsoid, and rotates and
% translates it using the parameters. It also draws the original volume.

% Construct the meshgrid for the ellipsoid, with padding:
[a,b,c] = size(vol);
ap = ceil(0.25*a);
bp = ceil(0.25*b);
cp = ceil(0.25*c);
v1 = 1:b+2*bp;
v2 = 1:a+2*ap;
v3 = 1:c+2*cp;
[x1,y1,z1] = meshgrid(v1,v2,v3);

% Pad original volume:
volp = zeros(a+2*ap,b+2*ap,c+2*cp);
volp(ap+1:a+ap,bp+1:b+bp,cp+1:c+cp) = vol;

% Apply the rotation using eigenvectors, and translation using centroids:
xc = C(1)+bp;
yc = C(2)+ap;
zc = C(3)+cp;
%Vt = V'./det(V');  % if eigenvalues not sorted
Vt = V./det(V);     % if eigenvalues sorted
x_rot = Vt(1,1)*(x1-xc) + Vt(1,2)*(y1-yc) + Vt(1,3)*(z1-zc);
y_rot = Vt(2,1)*(x1-xc) + Vt(2,2)*(y1-yc) + Vt(2,3)*(z1-zc);
z_rot = Vt(3,1)*(x1-xc) + Vt(3,2)*(y1-yc) + Vt(3,3)*(z1-zc);

% Construct the rotated ellipsoid:
le1 = lgths(1);
le2 = lgths(2);
le3 = lgths(3);
radius =  x_rot.^2/le1^2 + y_rot.^2/le2^2 + z_rot.^2/le3^2;
ellipsoid = radius<=1;
ellipsoid = double(ellipsoid);

% Draw the original volume (padded):
figure;
vol3d('cdata',volp);
colormap lines; view(3); axis image

% Draw the rotated ellipsoid (padded):
figure;
vol3d('cdata',ellipsoid);
colormap lines; view(3); axis image