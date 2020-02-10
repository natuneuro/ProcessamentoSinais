function imagens = CriarImagensEntrada(sinais_divididos_delta_theta, sinais_divididos_alpha_beta, sinais_divididos_gama)
% 
    quantidade_imagens = size(sinais_divididos_delta_theta, 2);
    imagens = cell(1, quantidade_imagens);

    for i = 1:quantidade_imagens
        inicio_amostra = sinais_divididos_delta_theta.tempo_inicio;
        fim_amostra = sinais_divididos_delta_theta.tempo_fim;
        
        imagens{i} = ImagemEntrada(sinais_divididos_delta_theta, sinais_divididos_alpha_beta, sinais_divididos_gama, inicio_amostra, fim_amostra);
    end
end

