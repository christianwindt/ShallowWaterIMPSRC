clear all
close all
% pkg load signal
gamma=3.3;
endTime=16;
% Input for shallow water
Tp=1.7652;
Hs=0.006;
T=[1.1:0.1:4];
d=0.074;
% Input for intermediate water
% Tp=1.1;
% Hs=0.04;
% T=[0.7:0.1:2.5];
% d=0.25;
%%%%%%%%%%%%%%%%%%%%%%%%%
timeStep=Tp/100;%0.01;
f=1./T;
omega=2*pi.*f;
df=f(2)-f(1);
Ao=Hs/2;
to=8;
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
   Ursell(j)=2*a(j)*Lam(i)^2/d^3;
   dBYl(j) = d/Lam(j);
end
eta=0;
for jj=1:length(f)
  eta=eta+a(jj)*cos(k(jj)*(dx)-omega(jj)*(t-to));
end

%Ramp up over ramp

L=length(eta);
tuk = tukeywin(L,0.9);
eta=tuk'.*eta;

figure
Time=[t];
Elevation=[eta];
plot(Time,Elevation);

figure
ax = plotyy(f,a,f,Ursell)
ylabel (ax(1), 'Amplitue [m]');
ylabel (ax(2), 'Ursell No');
xlabel (ax(1), 'Frequency [Hz]');

figure
plot(f,dBYl,'k','LineWidth',3);hold on;
plot([f(1) f(end)],[0.5 0.5],'r--','LineWidth',3);
plot([f(1) f(end)],[0.05 0.05],'r--','LineWidth',3)
xlabel('Frequency [Hz]');
ylabel('d/L');
grid on;

% %Time domain analysis of time trace
% [PKS, LOC, EXTRA] = findpeaks(Elevation,'DoubleSided');
% [v,j]=max(PKS);
% %Estimate waveheight
% H=v-PKS(j-1)
% %Estimate Period
% T=Time(LOC(j))-Time(LOC(j-2))
% Lambda=dispersion('d',d,'T',T)
% UrsellTimetrace=H*Lambda^2/d^3