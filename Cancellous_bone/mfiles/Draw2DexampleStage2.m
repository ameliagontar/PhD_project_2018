function Draw2DexampleStage2(drawx,drawy)

% September 17 2014 (Rostock)
%
% This program uses input arrays drawx and drawy generated by
% Draw2example.m to draw an irregular figure in the plane. The initial
% intention was that Draw2example.m be used to draw the figure, but it was
% decided that using one program to generate the 'control points' and
% another to draw the figure would be easier. The arrays drawx and drawy
% are stored in a file called controlpoints.mat

[n,m20] = size(drawx);

m = 50;  % number of interpolation points between control points.
xvec = zeros(1,n*m);
yvec = zeros(1,n*m);

for k = 1:n
    cxvec = drawx(k,:);
    cyvec = drawy(k,:);
    nz1vec = find(abs(cxvec) > 0);
    nz2vec = find(abs(cyvec) > 0);
    nz1 = length(nz1vec);
    nz2 = length(nz2vec);
    nz = max(nz1,nz2);
    cxvec = cxvec(1:nz);
    cyvec = cyvec(1:nz);
    t = 1:nz;
    tt = linspace(1,nz,m);
    xx = spline(t,cxvec,tt);
    yy = spline(t,cyvec,tt);
    a = m*(k-1) + 1;
    b = m*k;
    xvec(a:b) = xx';
    yvec(a:b) = yy';
end

subplot('position',[0 0 1 1])
xvec = [xvec xvec(1)];
yvec = [yvec yvec(1)];
patch(xvec,yvec,[.85 .9 .5])
hold on


% draw the oriented thicknesses
p = -.1;
q = .1;
plot(p,q,'or','linewidth',2)
v1 = .39;
plot([p;p],[q;v1],'r','linewidth',2)
v5 = .125;
plot([p;p],[q;-v5],'r','linewidth',2)
v3 = .95;
plot([p;v3],[q;q],'r','linewidth',2)
v7 = .7;
plot([p;-v7],[q;q],'r','linewidth',2)
t2 = .338;
v2 = sqrt(2)*t2;
plot([p;p+t2],[q;q+t2],'r','linewidth',2)
t4 = .13;
v4 = sqrt(2)*t4;
plot([p;p+t4],[q;q-t4],'r','linewidth',2)
t8 = .74;
v8 = sqrt(2)*t8;
plot([p;p-t8],[q;q+t8],'r','linewidth',2)
t6 = .5;
v6 = sqrt(2)*t6;
plot([p;p-t6],[q;q-t6],'r','linewidth',2)

axis([-1 1 -1 1])
axis square
axis off

vp = round(100*[v1 v2 v3 v4 v5 v6 v7 v8]);
disp('thickness vector')
disp(vp)




