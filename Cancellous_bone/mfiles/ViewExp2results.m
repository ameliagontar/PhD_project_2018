function ViewExp2results

% August 29 2014 (Rostock)
%
% display results from experiment 2

% construct figure showing results for 10 clusters per sub-block, meaning
% 90 initial clusters before merging.

% plot results for best combination of three features

disp('Results from Experiment 2 August 2014. The programs used to generate')
disp('these results are Exp2V2.m, Exp2V2F2.m and Exp2V2F3.m. Initially each')
disp('sub-block is used to determine 10 features. These are merged until no')
disp('pairs of features satisfy the merging criterion.')

% Produce a figure to summarize the results

load Exp2V2C10F3fullAug29.mat

meanF3 = mean(NOFmat);
meanA3 = mean(ACCmat);
stdA3 = std(ACCmat);
L3 = LamVec;
plot(meanF3,meanA3,'-r','linewidth',2)
hold on
plot(meanF3,meanA3+stdA3,':r')
plot(meanF3,meanA3-stdA3,':r')

% plot results for best combination of two features
load Exp2V2C10F2fullAug29.mat

meanF2 = mean(NOFmat);
meanA2 = mean(ACCmat);
stdA2 = std(ACCmat);
L2 = LamVec;
plot(meanF2,meanA2,'--b','linewidth',2)
plot(meanF2,meanA2+stdA2,':b')
plot(meanF2,meanA2-stdA2,':b')

% plot results for best single feature
load Exp2V2C10fullAug28.mat

meanF1 = mean(NOFmat);
meanA1 = mean(ACCmat);
stdA1 = std(ACCmat);
plot(meanF1,meanA1,'-.m','linewidth',2)
plot(meanF1,meanA1+stdA1,':m')
plot(meanF1,meanA1-stdA1,':m')

text(3,.72,' - best 3 features','color','r','fontsize',18)
text(3,.68,'- - best 2 features','color','b','fontsize',18)
text(3,.64,'- . best single feature','color','m','fontsize',18)
set(gca,'xtick',[0 20 40 60 80],'fontsize',18)
set(gca,'ytick',[.3 .4 .5 .6 .7],'fontsize',18)
axis([0 90 .25 .75])
xlabel('Number of features','fontsize',18)
ylabel('Proportion correct','fontsize',18)

% Display numerical results
disp(' ')
disp(['For best 3 features'])
F3mat = [L3 ; meanF3 ; meanA3];
txtmat = [
    'Lambda    ';
    'No. Feats ';
    'Accuracy  '];
dispmat3 = [txtmat num2str(F3mat)];
disp(dispmat3)

disp(' ')
disp(['For best 2 features'])
F2mat = [L2 ; meanF2 ; meanA2];
txtmat = [
    'Lambda    ';
    'No. Feats ';
    'Accuracy  '];
dispmat2 = [txtmat num2str(F2mat)];
disp(dispmat2)

disp(' ')
disp(['For best single feature: lambda'])
F1mat = [L2 ; meanF1 ; meanA1];
txtmat = [
    'Lambda    ';
    'No. Feats ';
    'Accuracy  '];
dispmat1 = [txtmat num2str(F1mat)];
disp(dispmat1)