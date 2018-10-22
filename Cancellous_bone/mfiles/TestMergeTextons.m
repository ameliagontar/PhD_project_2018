function TestMergeTextons

% August 26 2014 (Rostock)
%
% construct a simple example to test the program MergeTextons.m

C1 = randn(7,4);
C2 = randn(8,4)+2;
C3 = randn(6,4)+8;

T1 = mean(C1);
T2 = mean(C2);
T3 = mean(C3);

GFAs = [C1 ; C3 ; C2];
IDvec = [ones(7,1) ; 2*ones(6,1) ; 3*ones(8,1)];
GFA =[IDvec GFAs];

Tex = [T1 ; T3 ; T2];

disp('Original feature space')
disp(GFA)
disp(' ')
disp('Orignal texton array')
disp(Tex)
disp(' ')

lambda = 8;
[GFA,Tex] = MergeTextons(GFA,Tex,lambda);

disp('New feature space')
disp(GFA)
disp(' ')
disp('New texton array')
disp(Tex)
disp(' ')