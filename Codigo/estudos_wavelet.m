close all;
clc;

[h_e,r_e] = edfread('00000883_s003_t000.edf'); %Epilepsia
[h_n,r_n] = edfread('00006801_s001_t001.edf'); %Normal

%{
Arquivos da Base de Dados utilizada possuem frequência de amostragem de
250Hz
%}

[b,a] = butter(5,60/125); %Filtro lowpass com corte em 60Hz

s_e = r_e(1,:);
s_n = r_n(1,:);

%Cálculo da escala de tempo

t_e = (1/250)*(1:length(s_e));
t_n = (1/250)*(1:length(s_n));
 
s_e = filter(b,a,s_e);
s_n = filter(b,a,s_n);

figure
subplot(211)
plot(t_e,s_e)
xlabel('Tempo(s)')
ylabel('Amplitude(uV)')
title('Sinal Epiléptico')
subplot(212)
plot(t_n,s_n)
xlabel('Tempo(s)')
ylabel('Amplitude(uV)')
title('Sinal Normal')

%Transformada de Fourier dos sinais

ft_s_e = abs(fft(s_e));
ft_s_n = abs(fft(s_n));

%Calculo da frequencia

f_e = 250*(1:length(s_e))/length(s_e);
f_n = 250*(1:length(s_n))/length(s_n);

figure
subplot(211)
plot(f_e,ft_s_e)
xlabel('Frequencia(Hz)')
title('Transformada de Fourier do sinal epiléptico')
subplot(212)
plot(f_n,ft_s_n)
xlabel('Frequencia(Hz)')
title('Transformada de Fourier do sinal normal')

%Decomposição em DWT

wname = 'db5';

[LoD,HiD,LoR,HiR] = wfilters(wname);

[c,l] = wavedec(s_e,5,LoD,HiD); %Mudar para epiléptico ou normal (s_e ou s_n)
[cd1,cd2,cd3,cd4,cd5] = detcoef(c,l,[1 2 3 4 5]);
[ca5] = appcoef(c,l,wname,5);

%Feature Aquisition

s_std = std([std(cd1) std(cd2) std(cd3) std(cd4) std(cd5) std(ca5)]);
s_mean = mean([mean(cd1) mean(cd2) mean(cd3) mean(cd4) mean(cd5) mean(ca5)]);
s_max = max([max(cd1) max(cd2) max(cd3) max(cd4) max(cd5) max(ca5)]);
s_min = min([min(cd1) min(cd2) min(cd3) min(cd4) min(cd5) min(ca5)]);

feat_v = [s_std s_mean s_max s_min]'; %Feature Vector

%Plotagem das decomposições de Wavelet

%{
figure
subplot(611)
plot(cd1)
subplot(612)
plot(cd2)
subplot(613)
plot(cd3)
subplot(614)
plot(cd4)
subplot(615)
plot(cd5)
subplot(616)
plot(ca5)
%}

%Saídas de teste (1 = epilepsia e 0 = normal)

y_e = 1;
y_n = 0;

%Geração de feature vectors aletórios para treinamento da ANN

rng(0,'twister'); %Gerador de números aleatórios

%Desvio Padrão

%Epilepsia

a = 40;
b = 100;

std_x_e = (b-a).*rand(100,1) + a; %Vetor com 100 valores aleatórios entre 40 e 100

%Normal

a = 5;
b = 20;

std_x_n = (b-a).*rand(100,1) + a; %Vetor com 100 valores aleatórios entre 5 e 20

%Valor Médio

%Epilepsia

a = -6;
b = -2;

mean_x_e = (b-a).*rand(100,1) + a;

%Normal

a = -1;
b = 3;

mean_x_n = (b-a).*rand(100,1) + a;

%Valor Máximo

%Epilepsia

a = 1000;
b = 2000;

max_x_e = (b-a).*rand(100,1) + a;

%Normal

a = 200;
b = 600;

max_x_n = (b-a).*rand(100,1) + a;

%Valor Mínimo

%Epilepsia

a = -2000;
b = -1000;

min_x_e = (b-a).*rand(100,1) + a;

%Normal

a = -600; 
b = -200;

min_x_n = (b-a).*rand(100,1) + a;

%Vetor de entrada e sáida para treinamento

x_e = [std_x_e mean_x_e max_x_e min_x_e];
x_n = [std_x_n mean_x_n max_x_n min_x_n];

x = [x_e' x_n'];

y(1:4,1:100) = y_e;
y(1:4,101:200) = y_n;

v = [x,y];

%Rede Neural

net = feedforwardnet(20,'trainlm');
net = train(net,x,y);