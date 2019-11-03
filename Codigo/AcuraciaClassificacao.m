function acuracia = AcuraciaClassificacao(saidaReal,saidaRede)

    [c,cm,ind,per] = confusion(saidaReal,saidaRede); %'cm' é a matriz de confusão
    
    tp = cm(1,1); %True Positive
    fp = cm(1,2); %Fake Positive
    fn = cm(2,1); %Fake Negative
    tn = cm(2,2); %True Negative
    
    acuracia = ((tp+tn)/(tp+fp+fn+tn))*100; %Calculo da acuracia do método de classificação

end