classdef Evento
%   Estrutura de dado que possui informações dos eventos do EEG
    properties
        inicio        double
        fim           double
        tipo          string
        probabilidade double
    end

    methods
        % construtor da classe
        function this = Evento(inicio, fim, tipo, probabilidade)
            if (nargin == 4)
                this.inicio = inicio;
                this.fim = fim;
                this.tipo = tipo;
                this.probabilidade = probabilidade;
            end
        end
    end

end

