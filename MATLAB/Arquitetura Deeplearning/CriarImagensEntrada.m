function imagens = CriarImagensEntrada(sinais_divididos_delta_theta, sinais_divididos_alpha_beta, sinais_divididos_gama)
% 
    quantidade_imagens = size(sinais_divididos_delta_theta, 2);
    imagens = cell(1, quantidade_imagens);

    for i = 1:quantidade_imagens
        inicio_amostra = sinais_divididos_delta_theta{i}.tempo_inicio;
        fim_amostra = sinais_divididos_delta_theta{i}.tempo_final;
        
        imagens{i} = ImagemEntrada(sinais_divididos_delta_theta{i}, sinais_divididos_alpha_beta{i}, sinais_divididos_gama{i}, inicio_amostra, fim_amostra);
    end
end

