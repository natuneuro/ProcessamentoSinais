function [cd1,cd2,cd3,cd4,cd5, ca5] = ObterFaixasWavelet(sinal)
%   Detailed explanation goes here
    
    wname = 'db5';
    [LoD,HiD,LoR,HiR] = wfilters(wname);
    
    [c,l] = wavedec(sinal,5,LoD,HiD);
    
    [cd1,cd2,cd3,cd4,cd5] = detcoef(c,l,[1 2 3 4 5]);
    [ca5] = appcoef(c,l,wname,5);
end

