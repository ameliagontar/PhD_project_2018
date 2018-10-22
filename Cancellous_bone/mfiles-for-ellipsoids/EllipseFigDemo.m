function z = EllipseFigDemo

% August 30 2015
%
% This program provides examples for demonstrating and testing the program
% EllipseFit.m

% Example 1. Perfect ellipse

a = 4;
b = 15;
N = 20;
v = -N:N;
[x,y] = meshgrid(v);
A = pi/3;
cosA = cos(A);
sinA = sin(A);
X = x*cosA - y*sinA;
Y = x*sinA + y*cosA;
R = ((X - 2)/a).^2 + ((Y + 5)/b).^2;
z1 = R > 1;

z = z1 < 1;

figure; imagesc(z); colormap gray;

