%Create random trace to initialise AI learning
close all
clear all
load('InputRundata3.mat','Unewds','Timesteps');
pkg load signal

t=Timesteps';%(0.0:timeStep:endTime-delay)';
U=cell2mat(Unewds)';
figure
plot(U);hold on;plot(abs(U),'r');
U=num2cell(U);
t=num2cell(t);
Output=[cell2mat(t),cell2mat(U),zeros(size(cell2mat(U))),zeros(size(cell2mat(U))) ];
figure
plot(cell2mat(t),cell2mat(U))
fid = fopen('Wavemaker.dat', 'w');
fprintf(fid,'%i\n', size(t,1));
fprintf(fid,'(\n')
fprintf(fid,'(%f ( %f %f %f ))\n',Output' )
fprintf(fid,')\n')
fclose(fid)
save('-V7','Initialwavemakerinput.mat','t','U')
