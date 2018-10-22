function Draw3Dorientations

% September 1, 2014 (Rostock)
%
% Draw a figure to illustrated the directions for computing oriented
% thicknesses

Lveca = 4*[3 2 2 4 7 5 4 3 8 4 2 7 12];
Lvecb = 4*[1 2 3 1 4 5 9 6 2 4 3 4 11];

Total = (Lveca + Lvecb)

theta = [
    1  0  0;
    0  1  0;
    1  1  0;
    1 -1  0;
    1  0  1;
    0  1  1;
    1  0 -1;
    0  1 -1;
    1  1  1;
   -1  1  1;
    1 -1  1;
   -1 -1  1;
    0  0  1];

T2 = theta.^2;
T2norm = sqrt(sum(T2'));
normmat = T2norm'*ones(1,3);
thetaN = theta./normmat;

maxL = max(max(Lveca),max(Lvecb));
% Draw the spokes
figure(1)
p = [0;0;0];
for k = 1:13
    La = Lveca(k);
    x1 = thetaN(k,1)*La;
    y1 = thetaN(k,2)*La;
    z1 = thetaN(k,3)*La;
    
    plot3([0;x1],[0;y1],[0,z1],'linewidth',2)
    hold on
    
    Lb = Lvecb(k);
    x2 = -thetaN(k,1)*Lb;
    y2 = -thetaN(k,2)*Lb;
    z2 = -thetaN(k,3)*Lb;
    plot3([0;x2],[0;y2],[0;z2],'linewidth',2)
    
end
 
axis([-maxL maxL -maxL maxL -maxL maxL])
set(gca,'xtick',[],'ytick',[],'ztick',[])
axis square
grid on
return

% Draw the shape outline

x1 = 3;
x2 = -5;
y1 = 7;
y2 = -2;
xvec = [x1  0 x2  0 x1 0];
yvec = [ 0 y1  0 y2  0 0];

%xvec = [x1  0 x2  0 x1];
%yvec = [ 0 y1  0 y2  0];

disp([x1 x2 y1 y2])
figure(2)
plot([x1;x2],[0;0])
hold on
plot([0;0],[y1;y2])

M = [
    1 -2  4 -8  16  64;
    1 -1  1 -1   1   1;
    1  0  0  0   0   0;
    1  1  1  1   1   1;
    1  2  4  8  16  64;
    0  0  1  0   8  48]

%M = [
%    1 -2  4 -8  16 ;
%    1 -1  1 -1   1 ;
%    1  0  0  0   0 ;
%    1  1  1  1   1 ;
%    1  2  4  8  16 ]


sizeM = size(M)

detM = det(M)
invM = inv(M)
 

AFx = invM*xvec';
AFy = invM*yvec';
t = linspace(-2,2,400);
t2 = t.^2;
t3 = t.^3;
t4 = t.^4;
t6 = t.^6;
px = AFx(1) + AFx(2)*t + AFx(3)*t2 + AFx(4)*t3 + AFx(5)*t4 + AFx(6)*t6;
py = AFy(1) + AFy(2)*t + AFy(3)*t2 + AFy(4)*t3 + AFy(5)*t4 + AFy(6)*t6;

plot(px,py)




