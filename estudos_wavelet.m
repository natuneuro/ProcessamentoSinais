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

[c,l] = wavedec(s_n,5,LoD,HiD);
[cd1,cd2,cd3,cd4,cd5] = detcoef(c,l,[1 2 3 4 5]);
[ca5] = appcoef(c,l,wname,5);

%Feature Aquisition

s_std = std([std(cd1) std(cd2) std(cd3) std(cd4) std(cd5) std(ca5)]);
s_mean = mean([mean(cd1) mean(cd2) mean(cd3) mean(cd4) mean(cd5) mean(ca5)]);
s_max = max([max(cd1) max(cd2) max(cd3) max(cd4) max(cd5) max(ca5)]);
s_min = min([min(cd1) min(cd2) min(cd3) min(cd4) min(cd5) min(ca5)]);

feat_v = [s_std s_mean s_max s_min]; %Feature Vector

%Plotagem das decomposições de Wavelet

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

