function [drawx,drawy] = Draw2Dexample

% September 3 2014, Rostock
%
% Draw a 2D version to illustrate thickness measures


figure(1)
plot([0;0],[-1;1])
hold on
plot([-1;1],[0;0])
axis square
set(gca,'xtick',-1:.2:1,'ytick',-1:.2:1)

maxp = 20;
maxL = 10;
disp(['The maximum number of points for a single line is ' int2str(maxp)])
disp(['The maximum number of lines is ' int2str(maxL)])
drawx = zeros(maxL,maxp);
drawy = zeros(maxL,maxp);
dflag = 1;
linecnt = 0;
Nvec = zeros(maxL,1);
while dflag == 1
    [x,y] = ginput;
    N = length(x);
    t = 1:N;
    tt = linspace(1,N,300);
    xx = spline(t,x,tt);
    yy = spline(t,y,tt);
    plot(xx,yy)
    axis([-1 1 -1 1])
    linecnt = linecnt + 1;
    drawx(linecnt,1:N) = x;
    drawy(linecnt,1:N) = y;
    Nvec(linecnt) = N;
    dflag = input('Enter 1 to draw more, 0 to quit ')
end

drawx = drawx(1:linecnt,:);
drawy = drawy(1:linecnt,:);

disp(' ')
disp(drawx)
disp(' ')
disp(drawy)


figure(2)
for k = 1:linecnt
    xlong = drawx(k,:);
    ylong = drawy(k,:);
    N = Nvec(k);
    x = xlong(1:N);
    y = ylong(1:N);
    t = 1:N;
    tt = linspace(1,N,300);
    xx = spline(t,x,tt);
    yy = spline(t,y,tt);
    plot(xx,yy)
    hold on
end

    
