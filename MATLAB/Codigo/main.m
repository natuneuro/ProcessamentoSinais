%% Leitura e filtragem

[header_sinal, sinal, path, nome_arquivo] = ImportarArquivoEDF();

nome_arquivo = strrep(nome_arquivo, '.edf', '.tse');
caminho_arquivo_tse = strcat(path, nome_arquivo);

eventos = ImportarEventos(caminho_arquivo_tse);
sinal_associado = SinalEEG(header_sinal, sinal, eventos);

tamanho_sinal = length(sinal_associado.sinal);
Fs = sinal_associado.frequencia_de_amostragem;
tempo = 1/Fs:1/Fs:tamanho_sinal/Fs;

%% Amostragem em 3 frequencias (Hz) de interesse

delta_theta = [1 7];
alpha_beta = [8 30];
gama = [31 100];

sinal_delta_theta = sinal_associado.DecomporSinalEmFaixaDeFrequencia(delta_theta);
sinal_alpha_beta = sinal_associado.DecomporSinalEmFaixaDeFrequencia(alpha_beta);
sinal_gama = sinal_associado.DecomporSinalEmFaixaDeFrequencia(gama);

sinal_associado.AtribuirSinaisDasFrequenciasDeInteresse(sinal_delta_theta, sinal_alpha_beta, sinal_gama);

%% Divisao do sinal

tamanho_corte = 3; % segundos

sinais_divididos_delta_theta = DividirSinal(sinal_delta_theta, tamanho_corte, Fs);
sinais_divididos_alpha_beta = DividirSinal(sinal_alpha_beta, tamanho_corte, Fs);
sinais_divididos_gama = DividirSinal(sinal_gama, tamanho_corte, Fs);

%% Cria imagens para serem usadas de entrada

imagens_entrada = CriarImagensEntrada(sinais_divididos_delta_theta, sinais_divididos_alpha_beta, sinais_divididos_gama);
imagens_entrada = AssociarTrechosDeSinalComTipoDeEvento(imagens_entrada, eventos);

%% Configuração da Rede Convolucional

rede_convolucional = alexnet;
tamanho_entrada = rede_convolucional.Layers(1).InputSize;

% Ajuste da rede. remove-se as 3 ultimas camadasda rede pre-treinada, e 
% inclui-se as 3 novas para se ajustar ao problema
camadas_da_rede = rede_convolucional.Layers(1:end-3);
camadas_da_rede = [
    camadas_da_rede
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer
];

%% Normalizacao das imagens para serem utilizadas no treinamento

clear imagens imagens_entrada_normalizadas;

imagens = [ imagens_entrada{:} ];

tamanho_imagem = [ size(imagens(1).imagem_delta_theta) 3 size(imagens, 2) ];

imagens_entrada_normalizadas = zeros(tamanho_imagem);

for i = 1:size(imagens, 2)
    imagens_entrada_normalizadas(:, 1:size(imagens(i).imagem_delta_theta, 2), 1, i) = imagens(i).imagem_delta_theta;
    imagens_entrada_normalizadas(:, 1:size(imagens(i).imagem_alpha_beta, 2), 2, i) = imagens(i).imagem_alpha_beta;
    imagens_entrada_normalizadas(:, 1:size(imagens(i).imagem_gama, 2), 3, i) = imagens(i).imagem_gama;
end

%% Ajuste da dimensão das imagens, usando metodo do padding zero

imagens_entrada_normalizadas = imresize(imagens_entrada_normalizadas, [21 tamanho_entrada(1)]);

tamanho_imagens_entrada_normalizadas = size(imagens_entrada_normalizadas);
tamanho_maximo_imagem = max(tamanho_imagens_entrada_normalizadas(1:2));

quantidade_padding_a_adicionar = tamanho_maximo_imagem - tamanho_imagens_entrada_normalizadas(1:2);

imagens_entradas_normalizadas_com_padding = padarray(imagens_entrada_normalizadas, quantidade_padding_a_adicionar, 0, 'post');

%% Separacao dos dados para treinamento, validacao e para teste

saida_real = double([ imagens(:).ocorre_convulsao ]);

quantidade_dados = size(imagens_entradas_normalizadas_com_padding, 4);
indice_treino = ceil(quantidade_dados*0.7);
indice_validacao = ceil(quantidade_dados*0.85);

indices_aleatorios = randperm(quantidade_dados);

imagens_entradas_normalizadas_com_padding = imagens_entradas_normalizadas_com_padding(:, :, :, indices_aleatorios);
saida_real = saida_real(indices_aleatorios);

imagens_entrada_treinamento = imagens_entradas_normalizadas_com_padding(:, :, :, 1:indice_treino);
saida_real_treinamento = saida_real(1:indice_treino);

imagens_entrada_validacao = imagens_entradas_normalizadas_com_padding(:, :, :, indice_treino+1:indice_validacao);
saida_real_validacao = saida_real(indice_treino+1:indice_validacao);

imagens_entrada_teste = imagens_entradas_normalizadas_com_padding(:, :, :, indice_validacao+1:end);
saida_real_teste = saida_real(indice_validacao+1:end);

%% Treinamento da Rede Convolucional

miniBatchSize = 10;
options = trainingOptions('sgdm', ...
    'MiniBatchSize',miniBatchSize, ...
    'MaxEpochs',5, ...
    'InitialLearnRate',3e-4, ...
    'Shuffle','every-epoch', ...
    'Verbose',false, ...
    'ValidationData',{imagens_entrada_validacao, categorical(saida_real_validacao)},...
    'Plots','training-progress');

rede_treinada = trainNetwork(imagens_entrada_treinamento, ...
       categorical(saida_real_treinamento), camadas_da_rede, options);

%% Teste e aplicacao dos resultados

saida_resultante_da_rede = predict(rede_treinada, imagens_entrada_teste);

saida_resultante_da_rede = transpose(double(saida_resultante_da_rede(:,1) < saida_resultante_da_rede(:,2)));

matriz_confusao = plotconfusion(saida_real_teste, saida_resultante_da_rede, "Rede convolucional treinada (1 - ocorre convulsao, 0 - nao ocorre)");









