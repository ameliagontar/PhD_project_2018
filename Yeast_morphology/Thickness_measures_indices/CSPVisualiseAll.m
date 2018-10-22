function CSPVisualiseAll(array)

% 31 May 2017
%
% Draws a histogram to visualise each CSP-based feature, for all features
% listed in array. Each row of the array is one CSP-based feature, and each
% column represents an angle. 

figure;
[no_CSP,no_dir] = size(array);
for m = 1:no_CSP
    f = array(m,:);
    x = zeros(1,no_dir);
    for d = 1:no_dir
        x(d) = (d-1)*pi/no_dir;
    end
    subplot(4,4,m)
    w = 2/no_dir;
    L = x(no_dir)+2*w;
    W = (L/no_dir)*20;
    stem(x,f,'marker','none','linewidth',W);
    axis([x(1)-w x(no_dir)+w 0 2000]);
    xticks([])
    yticks([])
end