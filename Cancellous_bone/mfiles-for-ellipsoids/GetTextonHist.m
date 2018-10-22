function [text_occ_tr,class_labels_tr,text_occ_te,class_labels_te] = GetTextonHist(R,textons)

% 30 June 2016
%
% For each of the 90 sub-blocks using the existing fit ellipsoids
% (primitives), computes the texton maps and histograms of texton
% occurrences, to be used later for classification. 
%
% R is the radius of the original ball drawn (used as an input argument
% mainly to ensure directories are kept consistent), and textons is the
% array of textons, where each row represents one texton. text_occ_tr and
% text_occ_te are the (normalised) frequencies of texton occurrences for
% the training and testing set respectively, and class_labels_tr and
% class_labels_te are the corresponding class labels, from each of the 9
% sub-classes.

sdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles-for-ellipsoids/Primitives_only_axislengths';
hdir = '~/Dropbox/Amelia-Uni/Flinders-PhD/Project/Rat-bone-project/mfiles-for-ellipsoids';
newdir = ['R',int2str(R)];

[n,~] = size(textons);
load 'Cohortmat.mat'
cd(sdir)
cd(newdir)
curdir = dir;
L = length(curdir);
text_occ_tr = zeros(L,n);
text_occ_te = zeros(L,n);
class_labels_tr = cell(L,1);
class_labels_te = cell(L,1);
tr_cnt = 0;
te_cnt = 0;
for l = 1:L
    filename = curdir(l).name;
    if length(filename) > 9
        eval(['load ' filename])    % variable has name prims
        % Get texton map and histogram for current sub-block. Variable
        % prims lists all primitives that occur in that sub-block.
        [no_prims,~] = size(prims);
        textonmap = zeros(no_prims,1);
        for k = 1:no_prims
            curr_primitive = prims(k,:);
            dists = zeros(n,1);
            for i = 1:n
                dists(i) = norm(textons(i,:)-curr_primitive);
            end
            [~,idx] = min(dists);
            textonmap(k) = idx;
        end
        texton_no = hist(textonmap,1:n);
        texton_no = texton_no/sum(texton_no);
        %text_occ(m,:) = texton_no;
        % Find the corresponding group using Cohortmat:
        rat_no = filename(4:5);
        rat_no = str2double(rat_no);
        [~,c] = find(Cohortmat == rat_no);
        if or(c == 1,c == 2)
            classname = 'sham';
        elseif or(c == 3,c == 4)
            classname = 'ovx';
        elseif or(c == 5,c == 6)
            classname = 'ovx+zol';
        else
            warning('Something went wrong!')
        end
        block_no = filename(10);
        subclass = [classname,' block',block_no];
        if rem(c,2) == 1
            tr_cnt = tr_cnt+1;
            text_occ_tr(tr_cnt,:) = texton_no;
            class_labels_tr{tr_cnt,:} = subclass;
        elseif rem(c,2) == 0
            te_cnt = te_cnt+1;
            text_occ_te(te_cnt,:) = texton_no;
            class_labels_te{te_cnt,:} = subclass;
        end    
    end
end
text_occ_tr = text_occ_tr(1:tr_cnt,:);
text_occ_te = text_occ_te(1:te_cnt,:);
class_labels_tr = class_labels_tr(1:tr_cnt,:);
class_labels_te = class_labels_te(1:te_cnt,:);
cd(hdir)
        