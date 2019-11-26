function [ trechos_sinal_associados ] = AssociarTrechosDeSinalComTipoDeEvento(trechos_sinal, eventos)
%   Recebe trechos de sinal e associa eles ao evento que está ocorrendo no
%   respectivo momento
    
    quantidade_trechos = length(trechos_sinal);
    
    [nome_arquivo_lista_tipos_convulsao, path] = uigetfile('*.txt', 'Selecionar arquivo de lista de tipos de convulsão');
    caminho_arquivo = strcat(path, nome_arquivo_lista_tipos_convulsao);
    
    [arquivo_lista_tipos_convulsao, msg_erro] = fopen(caminho_arquivo, 'r');
    if arquivo_lista_tipos_convulsao == -1
        error(msg_erro);
    end
    
    lista_tipos_convulsao = textscan(arquivo_lista_tipos_convulsao, '%s', 'headerlines', 2);
    
    for i = 1:quantidade_trechos
        for i_evento = 1:length(eventos)
            trechos_sinal{i}.ocorre_convulsao = VerificarTrechoSinalOcorreConvulsao(trechos_sinal{i}, lista_tipos_convulsao{1}, eventos{i_evento});
            
            if trechos_sinal{i}.ocorre_convulsao
                break;
            end
        end
    end
    
    trechos_sinal_associados = trechos_sinal;
end

