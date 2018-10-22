function ToyExample_1

% August 3, 2014 (Rostock)
%
% Create image for a toy example of thickness textons in 2D to illustrate
% the need to merge textons.

% contruct two images of rectangles. Both have rectangles of size b x b,
% one also has rectangles of size a x b and the other also has rectangles
% of size b x a. The values are chosen from normal distributions N(a,s) and
% N(b,s). The locations are chosen radomly from a uniform distribution.

a = 7;
b = 30;
s = 3;
L = 800;
N = 30;
 
rng(2)

figure(1)

% Construct first texture image
subplot(2,2,1)
N2 = 2*N;
xvecB = zeros(N2,1);
yvecB = zeros(N2,1);
pcnt = 0;
XB = zeros(N2,1);
YB = zeros(N2,1);
for kr = 1:2
    for kN = 1:N
        if kr == 1
            xL = a; yL = b;
        elseif kr ==2
            xL = b; yL = b;
        end
            
        x = L*rand;
        y = L*rand;
        px = x;
        qx = x + xL + s*randn;
        py = y;
        qy = y + yL + s*randn;
        if (px < qx) & (py < qy)
            xvec = [px qx qx px px];
            yvec = [py py qy qy py];
            PH = patch(xvec,yvec,'b');
            set(PH,'edgecolor','b')
            hold on
            pcnt = pcnt + 1;
            xvecB(pcnt) = qx - px;
            yvecB(pcnt) = qy - py;
            XB(pcnt) = (qx + px)/2;
            YB(pcnt) = (qy + py)/2;
        end
    end
end

xvecB = xvecB(1:pcnt);
yvecB = yvecB(1:pcnt);
axis([0 L+b 0 L+b])
axis square
set(gca,'xtick',[ ],'ytick',[ ])
XB = XB(1:pcnt);
YB = YB(1:pcnt);

text(750,940,'Original images','fontsize',18)

% Construct second texture image        
subplot(2,2,2)
xvecR = zeros(N2,1);
yvecR = zeros(N2,1);
pcnt = 0;
XR = zeros(N2,1);
YR = zeros(N2,1);
for kr = 1:2
    for kN = 1:N
        if kr == 1
            xL = b; yL = b;
        elseif kr ==2
            xL = b; yL = a;
        end
            
        x = L*rand;
        y = L*rand;
        px = x;
        qx = x + xL + s*randn;
        py = y;
        qy = y + yL + s*randn;
        if (px < qx) & (py < qy)
            xvec = [px qx qx px px];
            yvec = [py py qy qy py];
            PH = patch(xvec,yvec,'r');
            set(PH,'edgecolor','r')
            %return
            hold on
            pcnt = pcnt + 1;
            xvecR(pcnt) = qx - px;
            yvecR(pcnt) = qy - py; 
            XR(pcnt) = (qx + px)/2;
            YR(pcnt) = (qy + py)/2;
        end
    end
end
xvecR = xvecR(1:pcnt);
yvecR = yvecR(1:pcnt);
disp(['number of points = ' int2str(pcnt)])
axis([0 L+b 0 L+b])
axis square
set(gca,'xtick',[ ],'ytick',[ ])
XR = XR(1:pcnt);
YR = YR(1:pcnt);

% Plot feature space
subplot(2,2,3)
plot(xvecB,yvecB,'.b')
hold on
plot(xvecR,yvecR,'.r')
set(gca,'xtick',[0 10 20 30 40],'fontsize',16)


title('Feature space','fontsize',18)
%sizexB = size(xvecB)

% Compute textons
[idB,CB,sumB,DB] = kmeans([xvecB yvecB],2);
[idR,CR,sumR,DR] = kmeans([xvecR yvecR],2);

text(50,40,['Blue textons'],'fontsize',18,'color','b')
text(55,33,['( 7.28 , 29.38)'],'fontsize',18,'color','b')
text(55,27,['(29.48 , 30.43)'],'fontsize',18,'color','b')

text(50,17,['Red textons'],'fontsize',18,'color','r')
text(55,10,['(29.32 , 7.77)'],'fontsize',18,'color','r')
text(55,3,['(30.27,30.00)'],'fontsize',18,'color','r')

disp(' ')
disp('Blue textons')
disp(CB)
disp(' ')
disp('Red textons')
disp(CR)

% Compute and display texton maps with 3 and 4 textons
figure(2)

% Four textons
% for the blue image
Tmat = [CB;CR];
Dmat = zeros(length(xvecB),4);
for kT = 1:4
    Txvec = ones(size(xvecB))*Tmat(kT,1);
    Tyvec = ones(size(yvecB))*Tmat(kT,2);
    Dmat(:,kT) = (xvecB - Txvec).^2 + (yvecB - Tyvec).^2;
end
[minD,minI] = min(Dmat');
%sizeminT = size(minI)
colv = [
    'mo';
    'go';
    'ko';
    'bo'];

subplot(2,2,1)
for kp = 1:length(XB)
    plot(XB(kp),YB(kp),colv(minI(kp),:))
    hold on
end
axis([0 L+b 0 L+b])
axis square
set(gca,'xtick',[ ],'ytick',[ ])
text(730,940,'Texton maps - 4 textons','fontsize',18)

Dmat = zeros(length(xvecR),4);
for kT = 1:4
    Txvec = ones(size(xvecR))*Tmat(kT,1);
    Tyvec = ones(size(yvecR))*Tmat(kT,2);
    Dmat(:,kT) = (xvecR - Txvec).^2 + (yvecR - Tyvec).^2;
end
[minD,minI] = min(Dmat');

subplot(2,2,2)
for kp = 1:length(XR)
    plot(XR(kp),YR(kp),colv(minI(kp),:))
    hold on
end
axis([0 L+b 0 L+b])
axis square
set(gca,'xtick',[ ],'ytick',[ ])


% Three textons
% for the blue image
Tmat = [CB;CR];
Tmat = [Tmat(1,:) ; Tmat(3,:) ; (Tmat(2,:)+Tmat(4,:))/2];
Dmat = zeros(length(xvecB),3);
for kT = 1:3
    Txvec = ones(size(xvecB))*Tmat(kT,1);
    Tyvec = ones(size(yvecB))*Tmat(kT,2);
    Dmat(:,kT) = (xvecB - Txvec).^2 + (yvecB - Tyvec).^2;
end
[minD,minI] = min(Dmat');
%sizeminT = size(minI)
%colv = [
%    'mo';
%    'go';
%    'bo';
%    'ko'];

subplot(2,2,3)
for kp = 1:length(XB)
    plot(XB(kp),YB(kp),colv(minI(kp),:))
    hold on
end
axis([0 L+b 0 L+b])
axis square
set(gca,'xtick',[ ],'ytick',[ ])
text(730,940,'Texton maps - 3 textons','fontsize',18)

Dmat = zeros(length(xvecR),3);
for kT = 1:3
    Txvec = ones(size(xvecR))*Tmat(kT,1);
    Tyvec = ones(size(yvecR))*Tmat(kT,2);
    Dmat(:,kT) = (xvecR - Txvec).^2 + (yvecR - Tyvec).^2;
end
[minD,minI] = min(Dmat');

subplot(2,2,4)
for kp = 1:length(XR)
    plot(XR(kp),YR(kp),colv(minI(kp),:))
    hold on
end
axis([0 L+b 0 L+b])
axis square
set(gca,'xtick',[ ],'ytick',[ ])

