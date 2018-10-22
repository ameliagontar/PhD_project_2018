function cnt_array = CountSubsampledPixels

% 6 September 2016
%
% For each timestep in each sample, finds the array filament (i.e. the area
% from which we will subsample voxels for ellipse fitting), and counts the
% total number of voxels in this array. cnt_array is the array of on pixel
% counts for each timestep for each sample. It is of size 8 x 10, with each
% column representing the sample, s = {1,...,10} and each row representing
% the timestep, t = {1,...,8}.

load 'rawdata.mat'
cnt_array = zeros(8,10);
for s = 1:10
    for t = 1:8
        im = rawdata(:,:,t,s);
        [meanx,meany,r,filaments] = FindRadius(im);
        no_pixels = sum(sum(filaments));
        cnt_array(t,s) = no_pixels;
        imagesc(im); colormap gray; axis image;
        hold on
        plot(meanx,meany,'mx','linewidth',2)
        xmin = ceil(meanx-r);
        xmax = floor(meanx+r);
        x = xmin:xmax;
        y1 = meany - sqrt(r^2-(x-meanx).^2);
        y2 = meany + sqrt(r^2-(x-meanx).^2);
        plot(x,y1,'m')
        plot(x,y2,'m')
        title(['Sample ',int2str(s),', timestep ',int2str(t)],'fontsize',12)
        pause
    end
end