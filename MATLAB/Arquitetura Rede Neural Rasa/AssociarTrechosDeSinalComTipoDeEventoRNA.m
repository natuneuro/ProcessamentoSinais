function [ trechos_sinal_associados ] = AssociarTrechosDeSinalComTipoDeEventoRNA(trechos_sinal, eventos)
%   Recebe trechos de sinal e associa eles ao evento que está ocorrendo no
%   respectivo momento
    
    quantidade_trechos = length(trechos_sinal);
    
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
            trechos_sinal{i}.ocorre_convulsao = VerificarTrechoSinalOcorreConvulsaoRNA(trechos_sinal{i}, lista_tipos_convulsao, eventos{i_evento});
            
            if trechos_sinal{i}.ocorre_convulsao
                break;
            end
        end
    end
    
    trechos_sinal_associados = trechos_sinal;
end

