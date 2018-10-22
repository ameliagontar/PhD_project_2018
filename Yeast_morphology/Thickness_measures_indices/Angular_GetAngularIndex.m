function [spectrum,k_values,I_theta] = Angular_GetAngularIndex(F_theta)

% 31 October 2016
%
% Given a vector F_theta of values of the angular metric, computes the
% angular index of filamentation as defined in Binder 2015. spectrum is the
% angular metric spectrum and k_values is the vector of the corresponding
% values of k (independent variable). I_theta is the angular index of
% filamentation. 

% Manually compute the Fourier transform:
M = length(F_theta);
K = M/2;
FT_array = zeros(M,K+1);
for j = 1:M
    F_j = F_theta(j);
    x_j = -pi+2*pi*j/M;
    for k = 0:K
        term = F_j*exp(-1i*k*x_j);
        FT_array(j,k+1) = term;
    end
end
S = sum(FT_array);
f_k = zeros(1,K+1);
for l = 1:K+1
    k = l-1;
    if ~(k == K)
        coefficient = 1/M;
    else
        coefficient = 1/(2*M);
    end
    f_k(l) = coefficient*S(l);
end

% For each value of k, compute the spectrum:
spectrum = zeros(1,K+1);
for l = 1:K+1
    ft = f_k(l);
    spectrum(l) = abs(ft)^2;
end

% Compute angular index of filamentation:
spectrum = spectrum(2:K+1);
k_values = 1:K;
I_theta = sum(spectrum);
