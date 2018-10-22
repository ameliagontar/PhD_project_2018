function StandardAtts = ComputeStandardAtts

% November 10, 2014 (Rostock)
%
% This program computes the standard morphometric attributes of the 9
% subblocks in order to compare classification resuls with oriented
% thicknes textons. This program follows the program AllRats13Features.m
%
% The output array StandardAtts is of size 90 x 8. The columns are:
% column 1 rat id. A number 1 - 30.
% column 2 data block id. A number 1,2,3 (1 closest to growth plate)
% column 3 BS
% column 4 BSBV
% column 5 TBPF
% column 6 SMI
% column 7 EUL
% column 8 CONND


sdir = ['~/Dropbox/Adir/Research/Groups/BoneGroup/remodelling/RatData400/BreeRatData'];
Bdir = ['~/Dropbox/Adir/Research/Groups/BoneGroup/remodelling/Arashmfiles/supportmfiles'];
hdir = ['~/Dropbox/Adir/Research/Groups/BoneGroup/remodelling/Textons3D/mfiles'];

w08 = int2str(8);   % select blocks from week 8
avec = [1 101 201]; % the initial slices for the three blocks
L = 99;             % the number of slices per sub-block is L + 1

% Initialize the output array StandardAtts. 
StandardAtts = zeros(30,6);

% Main loop
cd(sdir)
curdir = dir;
[dirlen,w] = size(curdir);

ratcnt = 0; % count the rats
rowcnt = 0;

for kd = 1:dirlen
    sname = curdir(kd,1).name;
    namelen = length(sname);
    
    if namelen > 2
        c8 = sname(8);
        
        if isequal(w08,c8) == 1
            eval(['load ' sname])
            
            % test to see that rat id is correctly assigned.
            ratcnt = ratcnt + 1;
            if ratcnt < 10;
                testN = ['0' int2str(ratcnt)];
            else
                testN = int2str(ratcnt);
            end
            c45 = sname([4:5]);
            if strcmp(c45,testN) == 0
                dips('Error in rat index')
                return
            end

            % Compute the 6 attributes for every block in the current rat.
            for kb = 1:3
                DispVec = ['Rat No. ' int2str(ratcnt) ' ,  Block ' int2str(kb)];
                disp(DispVec)
                
                a = avec(kb);
                
                % The current 3D data block is called x
                % The sub-block extracted is called curB
                curB = x(:,:,a:a+L);      
                
                % Set the path the use the program analyse3d.m and apply
                % this program.
                cd(Bdir)
                [attvec] = analyse3d(curB);
                cd(sdir)
                
                % The program analyse3d.m computes 10 attributes but only 6
                % of these make sense for this project. These 6 are
                % extracted here.
                shortattvec = attvec([4 5 7 8 9 10]);
                
                % Update the output array.
                rowcnt = rowcnt + 1;
                StandardAtts(rowcnt,1) = ratcnt;
                StandardAtts(rowcnt,2) = kb;
                StandardAtts(rowcnt,3:8) = shortattvec;
                
            end
        end
    end
end
    
% Return to home directory
cd(hdir)
