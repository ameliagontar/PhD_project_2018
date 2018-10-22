function newim = AddBall(im)

% 19 July 2017

[A,B] = size(im);
newim = zeros(A,B);
for a = 1:A
    for b = 1:B
        pxl = im(a,b);
        if pxl == 2
            newim(a,b) = 0;
        elseif pxl == 3
            newim(a,b) = 2;
        elseif pxl == 1
            newim(a,b) = 1;
        end
    end
end