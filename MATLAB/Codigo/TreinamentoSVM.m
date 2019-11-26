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
        
        performance_fold.resultados_teste = double(transpose(resultado_dados_teste));
        performance_fold.resultado_esperado = double(saidas(:,teste));
        [roc_x, roc_y, threshold, auc] = perfcurve(performance_fold.resultado_esperado, performance_fold.resultados_teste, 1);
        
        performance_fold.roc_x = roc_x;
        performance_fold.roc_y = roc_y;
        performance_fold.auc = auc;
        
        performance_cada_fold{i} = performance_fold;
    end
    
    vetor_structs = [ performance_cada_fold{:} ];
    [valor, indice] = max([vetor_structs.auc]);
    
    plotconfusion(performance_cada_fold{indice}.resultado_esperado, performance_cada_fold{indice}.resultados_teste);
    figure; plot(performance_cada_fold{indice}.roc_x, performance_cada_fold{indice}.roc_y);
    xlabel('False positive rate');
    ylabel('True positive rate');
    title('ROC of the best SVM model trained');
end

