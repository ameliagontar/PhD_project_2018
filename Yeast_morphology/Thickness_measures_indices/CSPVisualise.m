function CSPVisualise(f,label_no)

% 31 May 2017
%
% Draws a histogram to visualise each CSP-based feature. Each bin
% represents an angle, and the height of each bin represents the length of
% the longest line segment lying entirely inside the colony at that angle.
% This is a means of visualising the CSPs that turn out to be important to
% the classification, without confusing the reader by creating an artificial
% central point. It is a much more honest method of representing the CSPs.
%
% f is the CSP that is to be graphed. It is a vector of length no_dir, with
% each entry being the length of the longest line segment that fits
% entirely inside the yeast colony. label_no is the label number of the CSP
% being graphed, and is needed as input simply to create a title.

no_dir = length(f);
x = zeros(1,no_dir);
for d = 1:no_dir
    x(d) = (d-1)*pi/no_dir;
end
figure;
w = 2/no_dir;
L = x(no_dir)+2*w;
W = (L/no_dir)*80;
stem(x,f,'marker','none','linewidth',W);
axis([x(1)-w x(no_dir)+w 0 2000]);
set(0,'DefaultTextInterpreter', 'latex')
xticks(x)
xlab = cell(1,no_dir);
for d = 1:no_dir
    g = gcd(d-1,no_dir);
    num = (d-1)/g;
    denom = no_dir/g;
    if num == 0
        xlab{d} = '0';
    elseif num == 1
        xlab{d} = ['\pi/',int2str(denom)];
    else
        xlab{d} = [int2str(num),'\pi/',int2str(denom)];
    end
end
xticklabels(xlab)
yticks([0,1000,2000])
set(gca,'fontsize',22)
xlabel('Angle','interpreter','latex','fontsize',24)
ylabel('Length ($\mu$m)','interpreter','latex','fontsize',24)
title(['CSP labelled number ',int2str(label_no)],'fontsize',26)