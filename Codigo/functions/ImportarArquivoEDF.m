function [header_arquivo, dados_sinal] = ImportarArquivoEDF()
%   Função que abre um explorador de arquivos para que seja selecionado o
%   arquivo edf
    [arquivo, path] = uigetfile('*.edf', 'Selecionar arquivo EDF');
    
    caminho_e_arquivo = strcat(path, arquivo);
    [header_arquivo, dados_sinal] = edfread(caminho_e_arquivo);
end

