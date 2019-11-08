function [ modelo_svm ] = TreinamentoSVM(entradas, saidas)
%   Utiliza a ferramenta de treinamento de uma Support Vector Machine
%   Linear. Retorna o objeto matlab referente ao modelo treinado
    
    indices = crossvalind('KFold', size(entradas, 2), 10);
    
    performance_cada_fold = cell(1, 10);
    
    for i = 1:10
        teste = (i == indices);
        treinamento = ~teste;
        
        modelo_svm = fitcsvm(transpose(entradas(:,treinamento)), transpose(saidas(:,treinamento)),...
            'KernelFunction', 'rbf', 'Standardize',true);
    
        resultado_dados_teste = predict(modelo_svm, transpose(entradas(:,teste)));
        
        [verdadeiros_positivos, falso_positivos, falso_negativos, verdadeiros_negativos, acuracia] = ...
            AcuraciaClassificacao(saidas(:,teste), transpose(resultado_dados_teste));
        
        performance_fold.resultados_teste = transpose(resultado_dados_teste);
        performance_fold.resultado_esperado = saidas(:,teste);
        performance_fold.acuracia = acuracia;
        performance_fold.vp = verdadeiros_positivos;
        performance_fold.fp = falso_positivos;
        performance_fold.fn = falso_negativos;
        performance_fold.vn = verdadeiros_negativos;
        
        performance_cada_fold{i} = performance_fold;
    end
    
    vetor_structs = [ performance_cada_fold{:} ];
    [valor, indice] = max([vetor_structs.acuracia]);
    
    plotconfusion(performance_cada_fold{indice}.resultado_esperado, performance_cada_fold{indice}.resultados_teste);
end

