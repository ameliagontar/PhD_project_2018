function z = MakeShape

% August 30 2015
%
% The user creates a shape by manually adding balls to an image.

% Set the size of the image. The image is of size S x S.
S = 50;
z = zeros(S);

% set the radius of the 'paint brush'
R = 3.4;
Rn = ceil(R);
Rvec = -Rn:Rn;
[i,j] = meshgrid(Rvec);
ij = i.^2 + j.^2;
ptch = (ij <= R^2);

figure; imagesc(ptch)

imagesc(z)
% Add balls of radius R until the shape is defined
Bflag = 1;

disp(' ')
disp(' Click on locations for placing balls ')
disp(' Click outside the image to quit')
while Bflag == 1
    [x,y] = ginput(1);
    i = round(y);
    j = round(x);
    if i < Rn | i > S-Rn | j < Rn | j > S-Rn
        Bflag = 0;
    else
        z(i-Rn:i+Rn,j-Rn:j+Rn) = z(i-Rn:i+Rn,j-Rn:j+Rn) + ptch;
        z = (z > 0);
    end
    imagesc(z)
end
