function sinal_dividido = DividirSinal(sinal_EEG)
    
    %Deseja-se dividir o sinal em partes de 2 a 3 segundos, para isso é
    %necessário saber a frequencia de amostragem para poder dividir o sinal
    %corretamente
    
    signal_length = length(sinal_EEG); %Comprimento do sinal
    sampling_frequency = 250; %Frequência de amostragem do sinal
    n_amostras_3s = 3/(1/sampling_frequency); %Numero de amostras para 3s
    
    n = signal_length/n_amostras_3s; %Numero de subvetores
    
    s_d = zeros(n,n_amostras_3s + 1);
    
    for i=1:n
        s_d(i,1:(n_amostras_3s + 1)) = sinal_EEG(1:(n_amostras + 1));
        sinal_EEG = sinal_EEG(n_amostras + 1:signal_length);
    end

    sinal_dividido = s_d;
    
end