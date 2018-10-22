function SetCohorts

% July 30 2014 (Rostock)
%
% Set fixed training and testing sets for experiments
% 
% On August 2 2014, this program was changed to produce and store a single 
% output array called Cohortmat (file name and array name) of size 5 x 6.
% Each column is a list of 5 rat identification numbers. The columns are:
% column 1 = sham training rats
% column 2 = sham testing rats
% column 3 = ovx training rats
% column 4 = ovx testing rat
% column 5 = ovx+zol training rats
% column 6 = ovx+zol testing rats

Ddir = ['~/Dropbox/Adir/Research/Groups/BoneGroup/remodelling/mymfiles'];
hdir = ['~/Dropbox/Adir/Research/Groups/BoneGroup/remodelling/Textons3D/mfiles'];

cd(Ddir)
load ratdat     % Amelia 13 April 2015: did Murk give me this? I don't think so
                % I can't run this program but I do have the output matrix
                % Cohortmat.mat. Just use this for further experiments.
cd(hdir)

% In the file ratdat.m the group assignments are:
% 1 = sham
% 2 = ovx
% 3 = ovx+zol

G = ratdat(:,1);
I = ratdat(:,2);

Gname = [
    'sha';
    'ovx';
    'zol'];

TT = [
    'test ';
    'train'];
    
rng(1);

Cohortmat = zeros(5,6);
% for each group,
for k = 1:3
    disp(' ')
    disp(Gname(k,:));
    gvec = find(G == k);
    randvec = randperm(10);
    tranvec = I(gvec(randvec(1:5)));
    testvec = I(gvec(randvec(6:10)));
    tranout = ['tran' Gname(k,:)];
    testout = ['test' Gname(k,:)];
    %eval(['save ' tranout ' tranvec'])
    %eval(['save ' testout ' testvec'])
    disp(['training rats = ' int2str(tranvec')])
    disp(['testing rats  = ' int2str(testvec')])
    Cohortmat(:,2*k-1) = tranvec;
    Cohortmat(:,2*k) = testvec;
end
    
disp(Cohortmat)

save Cohortmat Cohortmat 

%eval(['save  Cohortmat Cohortmat'])
