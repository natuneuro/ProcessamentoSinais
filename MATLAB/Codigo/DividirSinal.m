function sinal_dividido = DividirSinal(sinal, tamanho_do_corte, frequencia_sinal)
%   Deseja-se dividir o sinal em partes de 2 a 3 segundos, para isso é
%   necessário saber a frequencia de amostragem para poder dividir o sinal
%   corretamente
%   Cada item do sinal dividido é uma struct com:
%   - Sinal
%   - Tempo de Inicio (em segundos)
%   - Tempo de Fim (em segundos)

    comprimento_sinal = length(sinal);
    numero_amostras_por_tempo = tamanho_do_corte/(1/frequencia_sinal);
    
    quantidade_intervalos = ceil(comprimento_sinal/numero_amostras_por_tempo);
    
    inicio = 1;
    final = numero_amostras_por_tempo;
    
    % O sinal dividido sera uma celula, isto, um array de arrays
    sinal_dividido = cell(1, quantidade_intervalos);
    
    trecho_sinal.sinal = sinal(inicio:final);
    trecho_sinal.tempo_inicio = 0;
    trecho_sinal.tempo_final = numero_amostras_por_tempo * (1/frequencia_sinal);
    
    sinal_dividido{1} = trecho_sinal;

    for i=2:quantidade_intervalos
        inicio = final + 1;
        final = i * numero_amostras_por_tempo;
        
        if(final > comprimento_sinal)
            trecho_sinal.sinal = sinal(inicio:end);
            trecho_sinal.tempo_inicio = inicio * (1/frequencia_sinal);
            trecho_sinal.tempo_final = length(sinal) * (1/frequencia_sinal);
            
            sinal_dividido{i} = trecho_sinal;
        else
            trecho_sinal.sinal = sinal(inicio:final);
            trecho_sinal.tempo_inicio = inicio * (1/frequencia_sinal);
            trecho_sinal.tempo_final = final * (1/frequencia_sinal);
            
            sinal_dividido{i} = trecho_sinal;
        end
    end
end