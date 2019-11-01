function caracteristicas_do_sinal = ObterCaracteristicasDoSinal(sinalEEG)
    
%   Faz o processamento do sinal, dividindo o mesmo em coeficientes de
%   wavelet e realizando a aquisição das características utilizadas para a
%   classificação do sinal.

%   Ficar ligado para interpretação da estrutura. Provavelmente será
%   necessário chamar sinalEEG{i}.evento.

    caracteristicas_do_sinal = cell(1, length(sinalEEG));

    for i=1:length(sinalEEG)
        [cd1,cd2,cd3,cd4,cd5, ca5] = ObterFaixasWavelet(sinalEEG{i}.sinal);

        s_std = std([std(cd1) std(cd2) std(cd3) std(cd4) std(cd5) std(ca5)]);
        s_mean = mean([mean(cd1) mean(cd2) mean(cd3) mean(cd4) mean(cd5) mean(ca5)]);
        s_max = max([max(cd1) max(cd2) max(cd3) max(cd4) max(cd5) max(ca5)]);
        s_min = min([min(cd1) min(cd2) min(cd3) min(cd4) min(cd5) min(ca5)]);

        caracteristicas_do_sinal{i} = [s_std s_mean s_max s_min]';
    end
end