function [ sinal_com_tendencia_removida ] = RemoverTendenciaNaoLinear(tempo, sinal)
%   Funcao que remove as subidas/descidas do sinal, tornando estatisticas, como a media, uniforme
    
    menor_bic = ObterMenorBayesInformationCriteria(tempo, sinal);

    coeficientes_polinomio = polyfit(tempo, sinal, menor_bic);
    resultado_polinomio_estimado = polyval(coeficientes_polinomio, tempo);

    sinal_com_tendencia_removida = sinal - resultado_polinomio_estimado;
end

