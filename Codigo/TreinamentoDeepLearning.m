function [ rede ] = TreinamentoDeepLearning(entradas, saidas)
%   Funcao que aplica o treinamento usando o metodo deep learning para a
%   classificação. Retorna o objeto da rede treinada.

    layers = [imageInputLayer([28 28 1])
              convolution2dLayer(5,20)
              reluLayer
              maxPooling2dLayer(2,'Stride',2)
              fullyConnectedLayer(10)
              softmaxLayer
              classificationLayer];


end

