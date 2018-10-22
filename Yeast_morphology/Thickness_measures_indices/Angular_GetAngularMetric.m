function [theta_bins,F_theta] = Angular_GetAngularMetric(im,Rcsr,M)

% 28 October 2016
%
% For an image of a yeast colony, im, computes the angular metric as
% defined in Binder 2015. Rcsr is as defined by Binder, and M is the number
% of bins used to compute the metric. The angular metric is a function of
% angle theta, -pi <= theta < pi. theta_bins is a vector of the values of
% the angle at the lower edge of each bin. F_theta is a vector of the
% values of the angular metric for each value of theta.

% Get the annular region of the domain:
[R,C] = find(im);
meanx = mean(C);
meany = mean(R);
[a,b] = size(im);
xv = 1:b;
yv = 1:a;
[X,Y] = meshgrid(xv,yv);
inner = ((X-meanx).^2+(Y-meany).^2 <= Rcsr^2);
inner = double(inner);
annular = im-inner;
for row = 1:a
    for col = 1:b
        p = annular(row,col);
        if p == -1
            annular(row,col) = 0;
        end
    end
end

% Get the "counts" for the angular metric, using annular region:
[A,B] = find(annular);
counts = zeros(M,1);
Delta = 2*pi/M;
no_pixels = length(A);
theta_bins = zeros(M,1);
for j = 1:M
    theta_lower = -pi+Delta*(j-1);
    theta_upper = -pi+Delta*j;
    theta_bins(j) = theta_lower;
    curr_count = 0;
    for idx = 1:no_pixels
        xcoord = B(idx);
        ycoord = A(idx);
        v_x = xcoord-meanx;
        v_y = ycoord-meany;
        v_l = sqrt(v_x^2+v_y^2);
        theta_temp = acos(v_x/v_l);
        if v_y > 0 
            theta = theta_temp;
        elseif v_y <= 0
            theta = -theta_temp;
        end
        if theta >= theta_lower && theta < theta_upper
            curr_count = curr_count+1;
        end
    end
    counts(j) = curr_count;
end
counts = flipud(counts);

% Calculate the normalisation factor:
n = sum(sum(annular));
norm_factor = n/M;

% Calculate the angular metric as a function of angle theta:
F_theta = counts./norm_factor;



