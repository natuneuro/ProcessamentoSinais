%% Leitura e filtragem

[header_sinal, sinal, path, nome_arquivo] = ImportarArquivoEDF();

nome_arquivo = strrep(nome_arquivo, '.edf', '.tse');
caminho_arquivo_tse = strcat(path, nome_arquivo);

eventos = ImportarEventos(caminho_arquivo_tse);
sinal_associado = SinalEEG(header_sinal, sinal, eventos);

tamanho_sinal = length(sinal_associado.sinal(1,:));

Fs = header_sinal.frequency(1);
tempo = 1/Fs:1/Fs:tamanho_sinal/Fs;

%% Divisão do sinal

sinal_dividido = DividirSinalRNA(sinal_associado.sinal(1,1:tamanho_sinal), 3, header_sinal.frequency(1));
trechos_sinal_associados = AssociarTrechosDeSinalComTipoDeEventoRNA(sinal_dividido, sinal_associado.eventos);

%% Aplicação de Wavelet e obtenção de caracteristicas do sinal (entrada) e as respectivas saidas

caracteristicas_do_sinal = ObterCaracteristicasDoSinal(trechos_sinal_associados);
caracteristicas_do_sinal = cell2mat(caracteristicas_do_sinal);

saida_cada_trecho = [ trechos_sinal_associados{:} ];
saida_cada_trecho = [ saida_cada_trecho(:).ocorre_convulsao ];

%% Treinamento Rede Neural

resultado_rede = TreinamentoRedeNeural(caracteristicas_do_sinal, saida_cada_trecho);

%% Treinamento SVM

TreinamentoSVM(caracteristicas_do_sinal, saida_cada_trecho);

%% Treinamento Deep Learning






