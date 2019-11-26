%% Arquitetura DeepLearning
%% Leitura dos sinais coletados

sinais_seizure = ImportarDadosEEGtxt('S');
sinais_seizure = [ sinais_seizure{:} ];

sinais_normais_O = ImportarDadosEEGtxt('O');
sinais_normais_O = [ sinais_normais_O{:} ];

sinais_normais_Z = ImportarDadosEEGtxt('Z');
sinais_normais_Z = [ sinais_normais_Z{:} ];

%% Divisão dos dados pra treinamento e teste

sinais_seizure_treinamento = sinais_seizure(:, 1:75);
sinais_seizure_teste = sinais_seizure(:, 76:100);

sinais_normais_O_treinamento = sinais_normais_O(:, 1:75);
sinais_normais_O_teste = sinais_normais_O(:, 76:100);

sinais_normais_Z_treinamento = sinais_normais_Z(:, 1:75);
sinais_normais_Z_teste = sinais_normais_Z(:, 76:100);

entradas_rede = horzcat(sinais_seizure_treinamento, sinais_normais_O_treinamento, sinais_normais_Z_treinamento);
saida_rede = [ ones(1, 75) zeros(1, 150)];

indices_permutados = randperm(size(entradas_rede, 2));
entradas_rede = entradas_rede(:, indices_permutados);
saida_rede = saida_rede(:, indices_permutados);
saida_rede = categorical(saida_rede);

%% Treinamento

rede_treinada = TreinamentoDeepLearning(entradas_rede, saida_rede, layers_2);

entradas_teste = horzcat(sinais_seizure_teste, sinais_normais_O_teste, sinais_normais_Z_teste);

resultado_rede = classify(rede_treinada, entradas_teste);



