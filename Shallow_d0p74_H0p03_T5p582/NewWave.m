clear all;
close all;
pkg load signal
% Input
gamma=3.3;
endTime=20;
Tp=5.582;
Hs=0.03;
timeStep=Tp/100;%0.01;
T=[Tp/1.57:0.1:Tp*2.27];
f=1./T;
omega=2*pi.*f;
df=f(2)-f(1);
Ao=Hs/2;
d=0.74;
to=10;
t=[0:timeStep:endTime];
dx=0;
%
beta=(0.06238*(1.094-0.01915*log(gamma)))/(0.23+0.0336*gamma-0.185*(1.9+gamma)^(-1));

for i=1:length(f);
	if f(i)<=(1/Tp)
		L=0.07;
		S(i)=beta*Hs^2*Tp^(-4)*f(i)^(-5)*exp(-1.25*(Tp*f(i))^(-4))*gamma^(exp(-(Tp*f(i)-1)^2/(2*L^2)));
	else
		L=0.09;
		S(i)=beta*Hs^2*Tp^(-4)*f(i)^(-5)*exp(-1.25*(Tp*f(i))^(-4))*gamma^(exp(-(Tp*f(i)-1)^2/(2*L^2)));
	end
  Lam(i)=dispersion('d',d,'T',T(i));
  k(i)=2*pi/Lam(i);
end

for j=1:length(f)
   a(j)=Ao*S(j)*df/sum(S.*df);
end
eta=0;
for jj=1:length(f)
  eta=eta+a(jj)*cos(k(jj)*(dx)-omega(jj)*(t.-to));
end

%Ramp up over ramp

L=length(eta);
tuk = tukeywin(L,0.9);
eta=tuk'.*eta;

%% Stretch signal
tTMP = t+5;
Time = [0:timeStep:endTime+10];
Elevation = [zeros(1,5/timeStep) eta zeros(1,(5/timeStep)+1)];


%Time=[t];
%Elevation=[eta];
plot(Time,Elevation);

save('-V7','Targeteta.mat','Time','Elevation')
