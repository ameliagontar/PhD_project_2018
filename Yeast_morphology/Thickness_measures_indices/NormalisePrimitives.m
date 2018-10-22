function prim_array_n = NormalisePrimitives(prim_array,tol)

% 21 November 2016
%
% For an array of primitive vectors, prim_array, where each row corresponds
% to one primitive vector, normalises each primitive vector according to
% the equation given in the Pattern Recognition paper. tol is the
% tolerance for the standard deviation. prim_array_n is the array of
% normalised primitive vectors.

[P,F]= size(prim_array);
prim_array_n = zeros(P,F);
for p = 1:P
    v_p = prim_array(p,:);
    m = mean(v_p);
    s = std(v_p);
    if s >= tol
        w_p = (v_p-m)/s;
    else
        w_p = v_p-m;
    end
    prim_array_n(p,:) = w_p;
end