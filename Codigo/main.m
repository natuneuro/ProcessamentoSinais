'main';

[header_sinal, sinal, path, nome_arquivo] = ImportarArquivoEDF();

nome_arquivo = strrep(nome_arquivo, '.edf', '.tse');
caminho_arquivo_tse = strcat(path, nome_arquivo);

eventos = ImportarArquivoTSE(caminho_arquivo_tse);
sinal_associado = AssociarSinalEEGComEventos(header_sinal, sinal, eventos);

tamanho_sinal = 2000;

sinal_filtrado = filtragemTKEO(sinal_associado.sinal(1,1:tamanho_sinal));

Fs = header_sinal.frequency(1);
tempo = 1/Fs:1/Fs:tamanho_sinal/Fs;

% Normalizacao dos sinais
sinal_associado_normalizado = sinal_associado.sinal(1,1:tamanho_sinal) ./ max(abs(sinal_associado.sinal(1,1:tamanho_sinal)));
sinal_filtrado_normalizado = sinal_filtrado ./ max(abs(sinal_filtrado));

figure(1)
subplot(2, 1, 1)
plot(tempo, sinal_associado_normalizado, 'b', 'linew', 2);
subplot(2, 1, 2)
plot(tempo, sinal_filtrado_normalizado, 'm', 'linew', 2);

%% Filtragem usando Bayes Information Criteria

sinal_com_tendencia_removida = RemoverTendenciaNaoLinear(tempo, sinal_associado.sinal(1,1:tamanho_sinal));
sinal_com_tendencia_removida_filtrado = filtragemTKEO(sinal_associado.sinal(1,1:tamanho_sinal));

sinal_com_t_r_normalizado = sinal_com_tendencia_removida ./ max(abs(sinal_com_tendencia_removida));
sinal_com_t_r_f_normalizado = sinal_com_tendencia_removida_filtrado./ max(abs(sinal_com_tendencia_removida_filtrado));

figure(2)
subplot(2, 1, 1)
plot(tempo, sinal_com_t_r_normalizado, 'b', 'linew', 2);
title('Sinal EEG com viés removido e normalizado')

subplot(2, 1, 2)
plot(tempo, sinal_com_t_r_f_normalizado, 'm', 'linew', 2);
title('Sinal EEG com viés removido, filtrado e normalizado')



