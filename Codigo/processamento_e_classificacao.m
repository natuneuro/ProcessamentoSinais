close all;
clc;

%{
    Mudar o método de treinamento, usar vetores de caracteríscas conhecidos
    para treinamento e os gerados aleatoriamente para teste de
    classificação. Futuramente aumentar a quantidade de entradas para
    treinamento, para isso, usar a base de dados de convulsão.
    
    OBS 1: Com somente duas entradas (normal e epiléptica) a rede ficou mau
    treinada. Decidi manter por enquanto as entradas geradas para treinar a
    rede. Aumentei a quantidade para 10.000 entradas, 5.000 epilépticas e
    5.000 normais, respectivamente nessa ordem.
%}

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

%Decomposição em DWT (Epilepsia)

wname = 'db5';

[LoD,HiD,LoR,HiR] = wfilters(wname);

[c,l] = wavedec(s_e,5,LoD,HiD);
[cd1,cd2,cd3,cd4,cd5] = detcoef(c,l,[1 2 3 4 5]);
[ca5] = appcoef(c,l,wname,5);

%Feature Aquisition

s_std = std([std(cd1) std(cd2) std(cd3) std(cd4) std(cd5) std(ca5)]);
s_mean = mean([mean(cd1) mean(cd2) mean(cd3) mean(cd4) mean(cd5) mean(ca5)]);
s_max = max([max(cd1) max(cd2) max(cd3) max(cd4) max(cd5) max(ca5)]);
s_min = min([min(cd1) min(cd2) min(cd3) min(cd4) min(cd5) min(ca5)]);

feat_v_e = [s_std s_mean s_max s_min]'; %Feature Vector

%Decomposição em DWT (Normal)

[c,l] = wavedec(s_n,5,LoD,HiD);
[cd1,cd2,cd3,cd4,cd5] = detcoef(c,l,[1 2 3 4 5]);
[ca5] = appcoef(c,l,wname,5);

%Feature Aquisition

s_std = std([std(cd1) std(cd2) std(cd3) std(cd4) std(cd5) std(ca5)]);
s_mean = mean([mean(cd1) mean(cd2) mean(cd3) mean(cd4) mean(cd5) mean(ca5)]);
s_max = max([max(cd1) max(cd2) max(cd3) max(cd4) max(cd5) max(ca5)]);
s_min = min([min(cd1) min(cd2) min(cd3) min(cd4) min(cd5) min(ca5)]);

feat_v_n = [s_std s_mean s_max s_min]'; %Feature Vector

%Saídas de teste (1 = epilepsia e 0 = normal)

y_e = 1;
y_n = 0;

%Geração de feature vectors aletórios para treinamento da ANN

rng(0,'twister'); %Gerador de números aleatórios

%Desvio Padrão

%Epilepsia

a = 40;
b = 100;

std_x_e = (b-a).*rand(5001,1) + a; %Vetor com 100 valores aleatórios entre 40 e 100

%Normal

a = 5;
b = 20;

std_x_n = (b-a).*rand(5001,1) + a; %Vetor com 100 valores aleatórios entre 5 e 20

%Valor Médio

%Epilepsia

a = -6;
b = -2;

mean_x_e = (b-a).*rand(5001,1) + a;

%Normal

a = -1;
b = 3;

mean_x_n = (b-a).*rand(5001,1) + a;

%Valor Máximo

%Epilepsia

a = 1000;
b = 2000;

max_x_e = (b-a).*rand(5001,1) + a;

%Normal

a = 200;
b = 600;

max_x_n = (b-a).*rand(5001,1) + a;

%Valor Mínimo

%Epilepsia

a = -2000;
b = -1000;

min_x_e = (b-a).*rand(5001,1) + a;

%Normal

a = -600; 
b = -200;

min_x_n = (b-a).*rand(5001,1) + a;

%Vetor de entrada e sáida para treinamento

feat_v = [feat_v_e feat_v_n];
y_v = [1 0];

x_e = [std_x_e mean_x_e max_x_e min_x_e];
x_n = [std_x_n mean_x_n max_x_n min_x_n];

x = [x_e' x_n'];

y(1,1:5001) = y_e;
y(1,5002:10002) = y_n;

%v = [x,y]

%Rede Neural

%Feedforward Neural Network

net = feedforwardnet(40,'trainlm');
[net,~] = train(net,x,y);
[net,~] = train(net,x,y);
[net,~] = train(net,x,y);
[net,~] = train(net,x,y);
[net,tr] = train(net,x,y);
