function [ ocorre_convulsao ] = VerificarTrechoSinalOcorreConvulsao(trecho_sinal, lista_tipos_convulsao, evento)
%   verifica, a partir de uma lista com os tipos de convulsao, o tipo do
%   evento e se ele pode ser considerado como convulsao ou nao
    if ((trecho_sinal.inicio_amostra > evento.inicio && trecho_sinal.inicio_amostra < evento.fim) || ...
        (trecho_sinal.fim_amostra > evento.inicio && trecho_sinal.fim_amostra < evento.fim))
        
        for i = 1:length(lista_tipos_convulsao)
            ocorre_convulsao = strcmp(lista_tipos_convulsao{i}, evento.tipo);

            if ocorre_convulsao
                break;
            end
        end
    else
        ocorre_convulsao = false;
    end
end

