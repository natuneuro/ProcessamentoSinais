function [ sinal_associado ] = AssociarSinalEEGComEventos(header_edf, dados_sinal, eventos)
%   Cria uma struct que possui o header do arquivo edf, os dados do sinal e
%   os eventos descritos em uma struct

    sinal_associado.header_edf = header_edf;
    sinal_associado.sinal = dados_sinal;
    sinal_associado.eventos = eventos;
end

