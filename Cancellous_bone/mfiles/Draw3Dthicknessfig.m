function Draw3Dthicknessfig

% September 2, 2014 (Rostock)
%
% Draw a figure to illustrate the oriented thickness measures. The figure
% consists of four vertical outlines to define the vertical variation and
% cross sections to define shape.

figure(1)
z = linspace(-2,2,400);
x = linspace(-2,2,400);
zz = (z/2).^2;
x1 = zz.*(1 - zz) + 1;
zs = ((z+.5)/2).^2;
x2 = zs.*(zs - 1) - 1;
y0 = zeros(size(z));
plot3(x1,y0,z)
hold on
plot3(x2,y0,z)
z1 = -.5 - (1.4*x).^2;
plot3(x,y0,z1)

axis([-2 2 -2 2 -2 2])
return

x = linspace(-2,12,400);
z1 = 3 - 2./(1 + (x.^2));
z1 = (x.^2).*(1 - (x/2.5).^2) + 1;
plot3(x,y0,z1)
axis([-2 2 -2 2 -2 3])


return


Cmat = rand(4,7);
Cmat(:,2) = zeros(4,1);
Cmat(:,4) = zeros(4,1);
Cmat(:,6) = zeros(4,1);
Svec = linspace(-1,1,200);
zz = zeros(size(Svec));

p1 = polyval(Cmat(1,:),Svec);
plot3(p1,zz,Svec)
hold on

p2 = polyval(Cmat(2,:),Svec);
plot3(zz,p2,Svec)

p3 = polyval(Cmat(3,:),Svec);
plot3(-p3,zz,Svec)

p4 = polyval(Cmat(4,:),Svec);
plot3(zz,-p4,Svec)