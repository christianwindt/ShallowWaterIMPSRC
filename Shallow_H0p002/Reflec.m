close all
clear all
%% define variables


timeStep=1.1/100;
%% Load Theory
% load('TheoryEta.mat')
etaResult=load('Elevation.mat','-ascii');
%% Load Data I
time= 0:timeStep:etaResult(end,1);
%dirName = strcat('.','/surfaceElevation/0.0119048/');
Depth=etaResult(1,2);%mean(etaResult(:,2));
WP1=[Depth; etaResult(:,2)]-Depth;
WP2=[Depth; etaResult(:,3)]-Depth;
WP3=[Depth; etaResult(:,4)]-Depth;
WP4=[Depth; etaResult(:,5)]-Depth;
WP1=interp1([0;etaResult(:,1)],WP1,time);
WP2=interp1([0;etaResult(:,1)],WP2,time);
WP3=interp1([0;etaResult(:,1)],WP3,time);
WP4=interp1([0;etaResult(:,1)],WP4,time);

%Replace NaN at start with mean
WP1(isnan(WP1))=Depth;
WP2(isnan(WP2))=Depth;
WP3(isnan(WP3))=Depth;
WP4(isnan(WP4))=Depth;
etaResult=etaResult-Depth;
%%
[frequency, xi, xr] = threeprobereflectionanalysis(WP3,WP2,WP4,0.15,0.225,Depth,timeStep);

figure
plot(frequency,xr,'r','LineWidth',3)
hold on; grid on;
plot(frequency,xi,'k','LineWidth',3)
legend('Reflected Wave','Incident Wave')
[C,I] = max(xi);
peak_freq = frequency(I)/(2*pi);
amp = C;
reflection_coeff = xr(I)/xi(I)
%% 
