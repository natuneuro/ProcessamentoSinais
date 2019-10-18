%clear all;
close all;
clc;

[hdr, read] = edfread('00000355_s003_t000.edf'); %Arquivo da base de dados (caso com epilepsia)

%[hdr, read] = edfread('00003612_s002_t001.edf'); %Arquivo da base de dados (caso sem epilepsia)

L = 1000; %Comprimento do sinal
ch = read(1,1:L);

Fs = 250; %Frequencia de amostragem em Hz
T = 1/Fs; %Período de amostragem em segundos
t = (0:L-1)*T; %Vetor de tempo

p = bandpower(abs(log(transpose(ch))), 250);

figure
plot(ch)
title('Sinal correspondente ao Canal 1')
xlabel('Amostras')
ylabel('Amplitude(uV)')

ft_ch = fft(ch);

modulo_fft_do_canal = abs(ft_ch/L);
P1 = modulo_fft_do_canal(1:L);
%P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(1:L)/L;

figure
plot(f,P1)
title('Spectro na frequência do Canal 1')
xlabel('Frequencia(Hz)')
ylabel('|P1(f)|')

wavelet_type = 'sym10';

[c,l] = wavedec(ch,4,wavelet_type);

[cd1,cd2,cd3,cd4] = detcoef(c,l,[1 2 3 4]);
ca4 = appcoef(c,l,wavelet_type);

max1 = max(cd1);
max2 = max(cd2);
max3 = max(cd3);
max4 = max(cd4);
max5 = max(ca4);

max_g = max([max1 max2 max3 max4 max5]);

d1 = wrcoef('d',c,l,wavelet_type,1);
d2 = wrcoef('d',c,l,wavelet_type,2);
d3 = wrcoef('d',c,l,wavelet_type,3);
d4 = wrcoef('d',c,l,wavelet_type,4);
a4 = wrcoef('a',c,l,wavelet_type,4);

figure

subplot(511)
plot(d1)
xlabel('Decomposição D1')

subplot(512)
plot(d2)
xlabel('Decomposição D2')

subplot(513)
plot(d3)
xlabel('Decomposição D3')

subplot(514)
plot(d4)
xlabel('Decomposição D4')

subplot(515)
plot(a4)
xlabel('Decomposição A4')

%{
figure

ft_d1 = fft(d1);

f = (Fs)*(1:length(d1))/length(d1);

P2 = abs(ft_d1/length(d1));
P1 = P2(1:length(d1));
%P1(2:end-1) = 2*P1(2:end-1);

subplot(5,1,1)
plot(f,P1)

ft_d2 = fft(d2);

f = (Fs)*(1:length(d2))/length(d2);

P2 = abs(ft_d2/length(d2));
P1 = P2(1:length(d2));
%P1(2:end-1) = 2*P1(2:end-1);

subplot(5,1,2)
plot(f,P1)

ft_d3 = fft(d3);

f = (Fs)*(1:length(d3))/length(d3);

P2 = abs(ft_d3/length(d3));
P1 = P2(1:length(d3));
%P1(2:end-1) = 2*P1(2:end-1);

subplot(5,1,3)
plot(f,P1)

ft_d4 = fft(d4);

f = (Fs)*(1:length(d4))/length(d4);

P2 = abs(ft_d4/length(d4));
P1 = P2(1:length(d4));
%P1(2:end-1) = 2*P1(2:end-1);

subplot(5,1,4)
plot(f,P1)

ft_a4 = fft(a4);

f = (Fs)*(1:length(a4))/length(a4);

P2 = abs(ft_a4/length(a4));
P1 = P2(1:length(a4));
%P1(2:end-1) = 2*P1(2:end-1);

subplot(5,1,5)
plot(f,P1)
%}