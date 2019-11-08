function [ menor_bic ] = ObterMenorBayesInformationCriteria(tempo, sinal)

    ordens_polinomio = (5:40)';
    
%   soma dos minimos quadrados
    smq = zeros(length(ordens_polinomio),1);
    
    tamanho_sinal = length(sinal);

%   itera sobre as ordens
    for i=1:length(ordens_polinomio)
    %	faz uma aproximacao polinomial e obtem os valores aproximados
        yAproximado = polyval(polyfit(tempo, sinal, ordens_polinomio(i)), tempo);
	%   Calcula o erro entre as saidas do sinal e aproximacao polinomial
        smq(i) = sum((yAproximado - sinal).^2)/tamanho_sinal;
    end

    bayes_information_criteria = tamanho_sinal*log(smq) + ordens_polinomio*log(tamanho_sinal);
    
    % Parametro com menor BIC (Bayes Information Criteria)
    [menor_valor_para_bic, indice_bic] = min(bayes_information_criteria);
    menor_bic = ordens_polinomio(indice_bic);
end

