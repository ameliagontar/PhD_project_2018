function prims = GetPrimitivesOneCow(im,N,d,s)

% 27 January 2017
%
% Computes a set of primitive vectors for one cow/steak. im is the image, 
% in this case of a steak. N is the number of voxels that we want to
% subsample at. d is the number of directions in which we measure
% thicknesses within each slice, and s is the step size used to take the
% measurements. prims is the array of primitives, with each row
% representing one primitive, and (d+1) columns. The first d columns are
% the thicknesses within the plane in d directions, and column d+1 is the
% between-plane thickness.

ind = find(im);
[r,c,p] = ind2sub(size(im),ind);
S = length(r);
x = N/S;
prims = zeros(S,d+1);
m = 0;
for k = 1:S
    if rand < x
        m = m+1;
        P = [r(k),c(k),p(k)];
        v_p = GetPrimitiveAtP_OneBP(im,P,d,s);
        prims(m,:) = v_p;
    end
end
prims = prims(1:m,:);
