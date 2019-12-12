%% Leitura e filtragem
%% leitura do arquivo
[header_sinal, sinal, path, nome_arquivo] = ImportarArquivoEDF();
% pegando dados do arquivo
nome_arquivo = strrep(nome_arquivo, '.edf', '.tse');
caminho_arquivo_tse = strcat(path, nome_arquivo);

eventos = ImportarArquivoTSE(caminho_arquivo_tse);
sinal_associado = SinalEEG(header_sinal, sinal, eventos);
%pegando o tamanho do sinal
tamanho_sinal = length(sinal_associado.sinal(1,:));
Fs = header_sinal.frequency(1);
tempo = 1/Fs:1/Fs:tamanho_sinal/Fs;

%% Divisão do sinal - transformando em versões menores para poder trabalhar com elas

sinal_dividido = DividirSinal(sinal_associado.sinal(1,1:tamanho_sinal), 3, header_sinal.frequency(1));
trechos_sinal_associados = AssociarTrechosDeSinalComTipoDeEvento(sinal_dividido, sinal_associado.eventos);

%% ---------------------------------- Análise Espectral -------------------------------------------------------------------------
%% Aplicação de Wavelet e obtenção de caracteristicas do sinal (entrada) e as respectivas saidas

caracteristicas_do_sinal = ObterCaracteristicasDoSinal(trechos_sinal_associados);
caracteristicas_do_sinal = cell2mat(caracteristicas_do_sinal);

saida_cada_trecho = [ trechos_sinal_associados{:} ];
saida_cada_trecho = [ saida_cada_trecho(:).ocorre_convulsao ];

% pegar partes dos sinais e tentar desennvolver aqui
% pegar a banda de power 
% p = bandpower(saida_cada_trecho)
% pband = bandpower(x,1000,[50 150]);
% ptot = bandpower(x,1000,[0 500]);
% per_power = 100*(pband/ptot)

% TreinamentoSVMNovo(pband, saida_de_cada_trecho, per_power)



%% ---------------------------------- SVM -------------------------------------------------------------------------
printf(
TreinamentoSVM(caracteristicas_do_sinal, saida_cada_trecho);







