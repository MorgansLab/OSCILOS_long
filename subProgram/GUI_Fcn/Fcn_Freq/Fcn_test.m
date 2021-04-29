function Fcn_test
global CI
[p,S] = polyfit(CI.FM.NL.Model3.uRatio,CI.FM.NL.Model3.Lf,30)

uRatio = 0:0.01:2;
LfRatio = polyval(p,uRatio);
figure
hold on
% plot(CI.FM.NL.Model3.uRatio,CI.FM.NL.Model3.Lf,'s')
plot(uRatio, LfRatio)

