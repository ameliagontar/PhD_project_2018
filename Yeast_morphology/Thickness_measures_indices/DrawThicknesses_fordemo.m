function DrawThicknesses_fordemo(im,r,c,no_dir,thicknesses_draw,phi)

% 29 November 2017

figure;
imagesc(im); colormap gray; axis image;
hold on
plot(c,r,'ko','linewidth',3)
for d = 1:no_dir
    theta = phi+(d-1)*(pi/no_dir);
    thck_neg = thicknesses_draw(2*d-1);
    thck_pos = thicknesses_draw(2*d);
    x_vec = [c-thck_neg*cos(theta),c+thck_pos*cos(theta)];
    y_vec = [r-thck_neg*sin(theta),r+thck_pos*sin(theta)];
    plot(x_vec,y_vec,'linewidth',2);
end

hold off
axis off