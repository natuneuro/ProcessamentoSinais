function [ rede ] = TreinamentoDeepLearning(entradas, saidas, layers)
%   Funcao que aplica o treinamento usando o metodo deep learning para a
%   classificação. Retorna o objeto da rede treinada.

    options = trainingOptions('sgdm');
    
    rede = trainNetwork(entradas, saidas,layers,options);
end

