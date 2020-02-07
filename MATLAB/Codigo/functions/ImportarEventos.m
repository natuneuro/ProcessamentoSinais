function [eventos] = ImportarEventos(caminho_arquivo)
%   Lê os arquivo .tse e retorna uma struct com as respectivas
%   informações:
%   - Nome do evento(vide documento explicando as bases de dados)
%   - Inicio
%   - Fim
%   - Probabilidade de ter ocorrido (padrão é 1)

    if(not(exist('caminho_arquivo')) || isempty(caminho_arquivo))
        [arquivo, path] = uigetfile('*.tse', 'Selecionar arquivo TSE');
        caminho_arquivo = strcat(path, arquivo);        
    end
    
    [arquivoID, msg_erro] = fopen(caminho_arquivo, 'r');
    if arquivoID == -1
        error(msg_erro)
    end
    
    conteudo = textscan(arquivoID, '%f %f %s %f', 'headerlines', 2);
    
    quantidade_eventos = length(conteudo{1}(:));
    
    eventos = cell(1, quantidade_eventos);
    
    for i = 1:quantidade_eventos
        evento = Evento(conteudo{1}(i), conteudo{2}(i), conteudo{3}{i}, conteudo{4}(i));
        
        eventos{i} = evento;
    end
    fclose(arquivoID);
end

