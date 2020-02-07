%% Leitura e filtragem

[header_sinal, sinal, path, nome_arquivo] = ImportarArquivoEDF();

nome_arquivo = strrep(nome_arquivo, '.edf', '.tse');
caminho_arquivo_tse = strcat(path, nome_arquivo);

eventos = ImportarEventos(caminho_arquivo_tse);
sinal_associado = SinalEEG(header_sinal, sinal, eventos);

Fs = sinal_associado.frequencia_de_amostragem;
tempo = 1/Fs:1/Fs:tamanho_sinal/Fs;

%% Amostragem em 3 frequencias de interesse

delta_theta = [1 7];
alpha_beta = [8 30];
gama = [31 100];

sinal_delta_theta = sinal_associado.DecomporSinalEmFaixaDeFrequencia(delta_theta);
sinal_alpha_beta = sinal_associado.DecomporSinalEmFaixaDeFrequencia(alpha_beta);
sinal_gama = sinal_associado.DecomporSinalEmFaixaDeFrequencia(gama);

%% Divisao do sinal







