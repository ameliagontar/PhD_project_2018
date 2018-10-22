function ShowMergingResults

% October 6 2014 (Prague)
%
% Draw a figure to show the results of merging textons for azimuth
% indedpendent data.

L = [.1 .25 .5 .75 1.0 1.3 1.6 2.0];
NOF = [90 89 81.8 69.8 56.3 40.5 31.2 22.2];
A = [.576 .580 .580 .587 .600 .576 .571 .562];
std = [.019 .019 .019 .033 .036 .019 .033 .033];

propM = (90 - NOF)/90;
plot(propM,A,'linewidth',2)
hold on
%return

plot(propM,A-std,'--')
plot(propM,A+std,'--')
