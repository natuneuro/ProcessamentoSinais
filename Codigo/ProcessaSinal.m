function sinal_processado = ProcessaSinal(sinalEEG)
    
    %Faz o processamento do sinal, dividindo o mesmo em coeficientes de
    %wavelet e realizando a aquisição das características utilizadas para a
    %classificação do sinal.
    
    wname = 'db5';
       
    [LoD,HiD,LoR,HiR] = wfilters(wname);

    [c,l] = wavedec(sinalEEG,5,LoD,HiD);
    [cd1,cd2,cd3,cd4,cd5] = detcoef(c,l,[1 2 3 4 5]);
    [ca5] = appcoef(c,l,wname,5);
    
    s_std = std([std(cd1) std(cd2) std(cd3) std(cd4) std(cd5) std(ca5)]);
    s_mean = mean([mean(cd1) mean(cd2) mean(cd3) mean(cd4) mean(cd5) mean(ca5)]);
    s_max = max([max(cd1) max(cd2) max(cd3) max(cd4) max(cd5) max(ca5)]);
    s_min = min([min(cd1) min(cd2) min(cd3) min(cd4) min(cd5) min(ca5)]);

   sinal_processado = [s_std s_mean s_max s_min]';

end