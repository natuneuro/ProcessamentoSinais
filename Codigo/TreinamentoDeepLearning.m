function [ rede ] = TreinamentoDeepLearning(entradas, saidas)
%   Funcao que aplica o treinamento usando o metodo deep learning para a
%   classificação. Retorna o objeto da rede treinada.
    
    layers = [sequenceInputLayer(4097)
              convolution2dLayer([4 4092], 6)
              maxPooling2dLayer([4 2046],'Stride',2)
              convolution2dLayer([4 2042], 5)
              maxPooling2dLayer([4 1021],'Stride',2)
              convolution2dLayer([10 1018], 4)
              maxPooling2dLayer([10 509],'Stride',2)
              convolution2dLayer([10 506], 4)
              maxPooling2dLayer([10 253],'Stride',2)
              convolution2dLayer([15 250], 4)
              maxPooling2dLayer([15 125],'Stride',2)
              fullyConnectedLayer(50)
              fullyConnectedLayer(20)
              fullyConnectedLayer(3)
              classificationLayer];

    options = trainingOptions('sgdm');
    
    rede = trainNetwork(entradas, saidas,layers,options);
    
    rede = fitnet([10 10]);
end

