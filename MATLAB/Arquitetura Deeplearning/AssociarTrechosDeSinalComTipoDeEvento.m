function [ trechos_sinal_associados ] = AssociarTrechosDeSinalComTipoDeEvento(trechos_sinal, eventos)
%   Recebe trechos de sinal e associa eles ao evento que está ocorrendo no
%   respectivo momento
    
    quantidade_trechos = size(trechos_sinal, 2);
    
    lista_tipos_convulsao = {
        "cpsz"
        "gnsz"
        "absz"
        "tnsz"
        "cnsz"
        "tcsz"
    };
    
    for i = 1:quantidade_trechos
        for i_evento = 1:length(eventos)
            trechos_sinal{i}.ocorre_convulsao = VerificarTrechoSinalOcorreConvulsao(trechos_sinal{i}, lista_tipos_convulsao, eventos{i_evento});
            
            if trechos_sinal{i}.ocorre_convulsao
                break;
            end
        end
    end
    
    trechos_sinal_associados = trechos_sinal;
end

