function sinal_dividido = DividirSinal(sinal, tamanho_do_corte, frequencia_sinal)
    %Deseja-se dividir o sinal em partes de 2 a 3 segundos, para isso é
    %necessário saber a frequencia de amostragem para poder dividir o sinal
    %corretamente
    
    comprimento_sinal = length(sinal);
    numero_amostras_por_segundo = tamanho_do_corte/(1/frequencia_sinal);
    
    quantidade_intervalos = ceil(comprimento_sinal/numero_amostras_por_segundo);
    
    inicio = 1;
    final = numero_amostras_por_segundo;
    
    % O sinal dividido sera uma celula, isto, um array de arrays
    sinal_dividido = cell(1, quantidade_intervalos);
    sinal_dividido{1} = sinal(inicio:final);

    for i=2:quantidade_intervalos
        inicio = final + 1;
        final = i * numero_amostras_por_segundo;
        
        if(final > comprimento_sinal)
            sinal_dividido{i} = sinal(inicio:end);
        else
            sinal_dividido{i} = sinal(inicio:final);
        end
    end
end