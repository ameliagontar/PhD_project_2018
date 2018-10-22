function DisplayHistograms(Harray)

% Aug 12 2014 Rostock
%
% This program displays histograms of 3D texton occurances. 

[m9,NT] = size(Harray);

Gmat = [
    'sham';
    ' ovx';
    ' zol'];



for kG = 1:3
    for kB = 1:3
        
        kk = 3*(kG-1) + kB;
        subplot(3,3,kk)
        curH = Harray(kk,:);
        bar(curH)
        axis([0 NT+1 0 .14])
        
        if kG == 1
            title(['sub-block ' int2str(kB)],'fontsize',16)
        end
        if kB == 1;
            txtvec =[Gmat(kG,:)];
            text(-30,.08,txtvec,'fontsize',16)
        end
    end
    
    
end
    