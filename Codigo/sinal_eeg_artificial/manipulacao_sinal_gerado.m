
Fs = 250;
t = 0:1/Fs:3;
ruido = randn(size(t));
ruido = (ruido - mean(ruido))/std(ruido);

delta = 1.0; theta = 6.0; alpha = 8.5; beta = 19.0; % frequencias conhecidas em hertz

sinal_eletrodo_frontal = sin(2*pi*delta*t) + sin(2*pi*theta*t) + sin(2*pi*alpha*t) + sin(2*pi*beta*t) + ruido;
sinal_eletrodo_frontal = sinal_eletrodo_frontal;


plot(t, sinal_eletrodo_frontal);

% Codigo do arthur %

% delta %
[b_delta_low,a_delta_low] = butter(5, delta/(Fs/2), 'low');
[b_delta_high, a_delta_high] = butter(5, delta/(Fs/2), 'high');

sinal_eletrodo_frontal_delta_filtrado_low = filter(b_delta_low, a_delta_low, sinal_eletrodo_frontal);
sinal_eletrodo_frontal_delta_filtrado_high = filter(b_delta_high, a_delta_high, sinal_eletrodo_frontal);
sinal_eletrodo_frontal_delta_filtrado = sinal_eletrodo_frontal_delta_filtrado_high + sinal_eletrodo_frontal_delta_filtrado_low;

% theta %
[b_theta_low,a_theta_low] = butter(5, theta/(Fs/2), 'low');
[b_theta_high, a_theta_high] = butter(5, theta/(Fs/2), 'high');

sinal_eletrodo_frontal_theta_filtrado_low = filter(b_theta_low, a_theta_low, sinal_eletrodo_frontal);
sinal_eletrodo_frontal_theta_filtrado_high = filter(b_theta_high, a_theta_high, sinal_eletrodo_frontal);
sinal_eletrodo_frontal_theta_filtrado = sinal_eletrodo_frontal_theta_filtrado_high + sinal_eletrodo_frontal_theta_filtrado_low;

% alpha %
[b_alpha_low,a_alpha_low] = butter(5, alpha/(Fs/2), 'low');
[b_alpha_high, a_alpha_high] = butter(5, alpha/(Fs/2), 'high');

sinal_eletrodo_frontal_alpha_filtrado_low = filter(b_alpha_low, a_alpha_low, sinal_eletrodo_frontal);
sinal_eletrodo_frontal_alpha_filtrado_high = filter(b_alpha_high, a_alpha_high, sinal_eletrodo_frontal);
sinal_eletrodo_frontal_alpha_filtrado = sinal_eletrodo_frontal_alpha_filtrado_high + sinal_eletrodo_frontal_alpha_filtrado_low;

% beta %
[b_beta_low,a_beta_low] = butter(5, beta/(Fs/2), 'low');
[b_beta_high, a_beta_high] = butter(5, beta/(Fs/2), 'high');

sinal_eletrodo_frontal_beta_filtrado_low = filter(b_beta_low, a_beta_low, sinal_eletrodo_frontal);
sinal_eletrodo_frontal_beta_filtrado_high = filter(b_beta_high, a_beta_high, sinal_eletrodo_frontal);
sinal_eletrodo_frontal_beta_filtrado = sinal_eletrodo_frontal_beta_filtrado_high + sinal_eletrodo_frontal_beta_filtrado_low;

%Cálculo da escala de tempo

sinal_eletrodo_frontal_filtrado = (sinal_eletrodo_frontal_beta_filtrado + sinal_eletrodo_frontal_delta_filtrado + sinal_eletrodo_frontal_theta_filtrado + sinal_eletrodo_frontal_alpha_filtrado);

hold on;
plot(t,sinal_eletrodo_frontal_filtrado)
xlabel('Tempo(s)')
ylabel('Amplitude(uV)')
title('Sinal Epiléptico original vs filtrado')
hold off;

% %% Transformada de Fourier dos sinais
% 
% ft_s_e = abs(fft(sinal_eletrodo_frontal_filtrado));
% 
% %Calculo da frequencia
% 
% f_e = Fs*(1:length(sinal_eletrodo_frontal_filtrado))/length(sinal_eletrodo_frontal_filtrado);
% 
% figure
% subplot(211)
% plot(f_e,ft_s_e)
% xlabel('Frequencia(Hz)')
% title('Transformada de Fourier do sinal epiléptico')
% 
% %Decomposição em DWT
% 
% wname = 'db5';
% 
% [LoD,HiD,LoR,HiR] = wfilters(wname);
% 
% [c,l] = wavedec(sinal_eletrodo_frontal_filtrado,5,LoD,HiD);
% [cd1,cd2,cd3,cd4,cd5] = detcoef(c,l,[1 2 3 4 5]);
% [ca5] = appcoef(c,l,wname,5);
% 
% %Feature Aquisition
% 
% s_std = std([std(cd1) std(cd2) std(cd3) std(cd4) std(cd5) std(ca5)]);
% s_mean = mean([mean(cd1) mean(cd2) mean(cd3) mean(cd4) mean(cd5) mean(ca5)]);
% s_max = max([max(cd1) max(cd2) max(cd3) max(cd4) max(cd5) max(ca5)]);
% s_min = min([min(cd1) min(cd2) min(cd3) min(cd4) min(cd5) min(ca5)]);
% 
% feat_v = [s_std s_mean s_max s_min]; %Feature Vector
% 
% %Plotagem das decomposições de Wavelet
% 
% figure
% subplot(611)
% plot(cd1)
% subplot(612)
% plot(cd2)
% subplot(613)
% plot(cd3)
% subplot(614)
% plot(cd4)
% subplot(615)
% plot(cd5)
% subplot(616)
% plot(ca5)
