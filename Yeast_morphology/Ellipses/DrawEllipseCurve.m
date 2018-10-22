function DrawEllipseCurve(im,cc,C,V1,V2,lgths)

% 19 July 2017
%
% A program based on DrawOneEllipse.m, but the ellipse is drawn as a curve
% rather than a meshgrid (binary image). cc is the connected component that
% the ellipse is fit to, C is the centroid of the ellipse, V1 and V2 are
% the unit direction vectors of the major and minor axes, respectively, and
% lgths is a vector of length two containing the lengths of the major and
% minor semi-axes. im is the original image.

xo = C(1);
yo = C(2);
a = lgths(1);
b = lgths(2);
V = [V1',V2'];

% Define the x and y coordinates without transformations:
x = -a:0.1:a+0.1;
y1 = -b*sqrt(1-(x./a).^2);
y2 = b*sqrt(1-(x./a).^2);

% Transform the coordinates:
Vt = V./det(V);
xt1 = Vt(1,1)*(x)+Vt(1,2)*(y1)+xo;
yt1 = Vt(2,1)*(x)+Vt(2,2)*(y1)+yo;
xt2 = Vt(1,1)*(x)+Vt(1,2)*(y2)+xo;
yt2 = Vt(2,1)*(x)+Vt(2,2)*(y2)+yo;

% Draw the original image im and the connected component cc:
imwithcc = im+2*cc;
newim = AddBall(imwithcc);
imflip = FlipNumbers(newim);
figure;
imagesc(imflip); colormap gray; axis image
%imagesc(im); colormap gray; axis image
hold on

% Plot the ellipse, including the centroid:
plot(xt1,yt1,'c','linewidth',3)
plot(xt2,yt2,'c','linewidth',3)
plot(xo,yo,'cx','linewidth',2)

% Plot the lengths and directions of the major and minor axes:
%majorx = [C(1)-lgths(1)*V1(1),C(1)+lgths(1)*V1(1)];
%majory = [C(2)-lgths(1)*V1(2),C(2)+lgths(1)*V1(2)];
%minorx = [C(1)-lgths(2)*V2(1),C(1)+lgths(2)*V2(1)];
%minory = [C(2)-lgths(2)*V2(2),C(2)+lgths(2)*V2(2)];
%plot(majorx,majory,'m','linewidth',3)
%plot(minorx,minory,'m','linewidth',3)
%hold off
%axis off

% Plot the lengths and directions of colony thicknesses:
%ell = [C,V1,V2,lgths];
%[~,~,xcoord_finish1,ycoord_finish1,xcoord_finish2,ycoord_finish2,xcoord_finish3,ycoord_finish3,xcoord_finish4,ycoord_finish4] = GetThicknessForEllipses(im,ell,stepsize);
%X_major = [xcoord_finish1,xcoord_finish2];
%Y_major = [ycoord_finish1,ycoord_finish2];
%X_minor = [xcoord_finish3,xcoord_finish4];
%Y_minor = [ycoord_finish3,ycoord_finish4];
%plot(X_major,Y_major,'m','linewidth',3)
%plot(X_minor,Y_minor,'m','linewidth',3)
hold off
axis off