function imflip = FlipNumbers(im)

% 21 November 2016

[A,B] = size(im);
imflip = zeros(A,B);
for a = 1:A
    for b = 1:B
        pxl = im(a,b);
        if pxl == 1
            imflip(a,b) = 2;
        elseif pxl == 2
            imflip(a,b) = 1;
        end
    end
end