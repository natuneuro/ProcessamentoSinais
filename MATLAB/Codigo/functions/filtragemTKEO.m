function [ sinal_filtrado ] = filtragemTKEO(sinal)
%   Aplica filtragem TKEO no canal passado como argumento, retornando outro
%   sinal que destaca somente os picos e anormalidades no sinal original

sinal_filtrado = sinal;
sinal_filtrado(2:end-1) = sinal(2:end-1).^2 - sinal(1:end-2).*sinal(3:end);
end

