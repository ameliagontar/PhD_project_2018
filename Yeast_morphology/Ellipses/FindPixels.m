function [pixel_cnt,Cratio,idx] = FindPixels(smpl)

% 19 July 2016
%
% For a binary 2D image (e.g. an image of a yeast sample), finds and counts
% all on pixels with at least one off neighbour. These pixels correspond to
% pixels at the boundary of the sample. 
%
% smpl is the sample image. pixel_cnt is the number of boundary pixels, and
% idx is a list of the coordinates of these boundary pixels in row, column
% format. Cratio is the "circumference ratio," which should equal 1 for a 
% perfect circle. A value greater than 1 represents some fuzziness. Cratio
% should be a measure of fuzziness.

[R,C] = size(smpl);
pixel_cnt = 0;
idx = zeros(R*C,2);
for r = 2:R-1
    for c = 2:C-1
        curr_pixel = smpl(r,c);
        patch = smpl(r-1:r+1,c-1:c+1);
        bdry_check = sum(sum(patch));
        if curr_pixel == 1 && bdry_check >= 1 && bdry_check <= 8
            pixel_cnt = pixel_cnt+1;
            idx(pixel_cnt,:) = [r,c];
        end
    end
end

idx = idx(1:pixel_cnt,:);

on_pixels = sum(sum(smpl));
Cratio = pixel_cnt/(2*sqrt(pi)*sqrt(on_pixels));
