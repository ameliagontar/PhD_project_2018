function DevelopClusters

% July 30 2014 (Rostock)
%
% The program tests the process of finding textons (clustering) and
% constructing texton maps. Amelia 20 April 2015: this program seems to
% ONLY run for the toy example at this stage. Will we be able to use it in
% subsequent steps of Murk's experiment?

sdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/my-FeatureArrays'];
hdir = ['~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles'];

cd(sdir)
VoxArray = load('rat01w08B1');
cd(hdir)

NC = 8; % number of clusters

% set toyflag = 1 to run toy example - then use 2 clusters
toyflag = 0;
if toyflag == 1
    
    NC = 2;
    
    thetamat = [
        3 0 0;
        8 5 5;
        5 8 5;
        0 3 0;
        5 5 8;
        0 0 3];
end


tic
disp('clustering step')
% clustering using k-means
[IDX,C,SUMD,D] = kmeans(VoxArray,NC);
toc

tic
disp('construct texton map')
% construct the texton map

if toyflag == 1
    VoxArray = [thetamat;
        0 0 0;
        7 7 7]
end

[Tmap,Dvec] = TextonMap(C,VoxArray)

return

% Compute standard deviations for distance of cluster members to cluster
% centers. This anticipates future steps and allows checking on toy
% examples
for k = 1:NC
    disp(['Texton ' int2str(k)])
    
    % current cluster center (current texton) (1 x 13)
    curtexton = C(k,:);
    disp(['center = ' int2str(round(curtexton))])
    
    % vector of indexes for vectors in the current cluster
    curidx = find(IDX == k); 
    
    % number of vectors in the current cluster
    curtot = length(curidx)
   
    % feature vectors for the current cluster (curtot x 13)
    curarray = thetamat(curidx,:);
    sizecurarray = size(curarray)
       
    % vector difference between cluster members and center (curtot x 13)
    onevec = ones(curtot,1);
    curdif = curarray - (onevec*C(k,:));
    sizecurdif = size(curdif)
    
    % std of points in current cluster
    curstd = sqrt(sum(sum((curdif.^2)'))/curtot);
    disp(['std = ' num2str(curstd)])
end

