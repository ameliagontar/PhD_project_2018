function [EC,EL,Adeg] = EllipseFit(z)

% August 30 2015
%
% This program accepts a binary image z as input and computes the ellipse 
% having the same area and the same principle eigen vectors as R, the set
% of 'on' pixels (pixels with value 1). The expected use of the program
% is in the case that R forms a connected set, but this is not necesssary 
% for the running of the program.
% The s
% Principal components are used to find the directions of maximum and 
% minimum information. These are the orientations of the eigen vectors of 
% z'z associated with the largest and smallest eigen values, respectively.
%
% The output parameters are as follows:
%
% EC - eccentricity of the best fitting ellipse
% EL - ellipticity of the best fitting ellipse
% Adeg - angle of the major eigenvector in degrees
%
% The user has the option of using the program in demo mode. In demo mode,
% the program displays the binary image patch and the best fitting ellipse.
% Setting DemoFlag = 1 implements the demo mode.
%
% NOTE: The diplay will only be reflect true geometry if z is a square
% image.

DemoFlag = 1;  % 1 turns on demo mode, any other value, demo mode is off


[y,x] = find(z);
meanx = mean(x);      % mean of x coordinates
meany = mean(y);      % mean of y coordinates
xc = x - mean(x);     % centralised x coordinates
yc = y - mean(y);     % centralised y coordinates
xx = [xc yc];         % array of centralised coordinates
CV = (xx')*xx;        % variance matrix
[V,D] = eig(CV);      % D is the diagonal array of singular values of CV
lam1 = abs(D(1,1));   % lam1 and lam2 are the eigenvalues of CV
lam2 = abs(D(2,2));

% Compute the angle A of the major axis with horizontal and verical angles
% treated as special cases.
if lam1 == 0
    E = length(x);
    if max(abs(CV(:,1))) == 0
        A = pi/2;
    elseif max(abs(CV(:,2))) == 0
        A = 0;
    else
        A = atan(V(2,2)/V(2,1));
    end
else
    E = sqrt(lam2/lam1);
    if V(2,1) == 0
        A = pi/2;
    else
        A = atan(V(2,2)/V(2,1));
    end    
end

Adeg = (180/pi)*A;               % Adeg is the angle A in degrees.
if Adeg > 90
    Adeg = Adeg - 90;
elseif Adeg < -90
    Adeg = Adeg + 90;
end

Areaz = sum(sum(z));             % area of the region R
E1 = sqrt(Areaz*E/pi);           % length of the major axis
E2 = sqrt(Areaz/(pi*E));         % length of the minor axis
EC = sqrt(1 - (E2/E1)^2);        % eccentricity

cosA = cos(A);
sinA = sin(A);

% construct ellipse of equivalent area and eccentricity
[m,n] = size(z);
[iv,jv] = meshgrid(1:n,1:m);
is = (iv - meanx);
js = (jv - meany);
Iv = js*sinA + is*cosA;
Jv = js*cosA - is*sinA;
RR = (Iv/E1).^2 + (Jv/E2).^2;
EE = (RR <= 1);

D = z - EE;
Dv = find(D > 0);
EL = 1 - length(Dv)/Areaz;       % ellipticity (compactness)



% If the demo mode flag is on, the remaing code displays the image and the
% best fitting ellipse.
if DemoFlag == 1
    
    figure; imagesc(z)
    colormap(gray)
    hold on

    t = linspace(0,2*pi,400);
    CA = cos(t-A)/E1;
    SA = sin(t-A)/E2;
    r = 1./sqrt((CA.^2 + SA.^2));
    plot(meanx+r.*cos(t),meany+r.*sin(t),'m','linewidth',2)
    plot(meanx,meany,'mx','linewidth',2)
    hold off
    %title('Original and ellipse','fontsize',14)
    axis off
    
end
   


