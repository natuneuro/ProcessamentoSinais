function [ ocorre_convulsao ] = VerificarTrechoSinalOcorreConvulsaoRNA(trecho_sinal, lista_tipos_convulsao, evento)
%   verifica, a partir de uma lista com os tipos de convulsao, o tipo do
%   evento e se ele pode ser considerado como convulsao ou nao
    if ((trecho_sinal.tempo_inicio > evento.inicio && trecho_sinal.tempo_inicio < evento.fim) || ...
        (trecho_sinal.tempo_final > evento.inicio && trecho_sinal.tempo_final < evento.fim))
        
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

