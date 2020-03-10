function [ dados ] = ImportarDadosEEGtxt(tipo_eeg)
%	Importa os dados EEG disponibilizados pela Universidade de Bonn

    caminho_dados_texto = strcat(pwd, '\Dados\dados_univ_bonn');
    
    arquivos_dados_seizure = dir(strcat(caminho_dados_texto, '\', tipo_eeg, '\*.txt'));
    
    nomes_arquivos_dados_seizure = { arquivos_dados_seizure.name };
    nomes_arquivos_dados_seizure = string(nomes_arquivos_dados_seizure);
    
    dados = cell(1, length(nomes_arquivos_dados_seizure));
    
    for indice = 1:length(nomes_arquivos_dados_seizure)
        caminho_arquivo = strcat(caminho_dados_texto, '\', tipo_eeg, '\', nomes_arquivos_dados_seizure(indice));
        [arquivoID, msg_erro] = fopen(caminho_arquivo, 'r');
        if arquivoID == -1
            error(msg_erro)
        end
        
        sinal = textscan(arquivoID, '%f');
        sinal = [ sinal{:} ];
        dados{indice} = sinal;
        fclose(arquivoID);
    end
end

