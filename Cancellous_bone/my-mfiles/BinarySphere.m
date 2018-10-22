function S = BinarySphere

N = 100;
radius = 49;    % needs to be less than N/2, otherwise the edge pixels will be cut off

S = zeros(N,N,N);

for i=1:N;
    for j=1:N;
        for k=1:N
  S(i,j,k)=(i-(N+1)/2)^2+(j-(N+1)/2)^2+(k-(N+1)/2)^2 <= radius^2;
  %or <radius^2
end;end;end
