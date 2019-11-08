classdef SinalEEG
%   Estrutura de dados que representa o sinal do EEG, junto com 
%   informações importantes
    
    properties
        header_edf
        sinal
        eventos
    end
    
    methods
        % Contrutor da classe
        function this = SinalEEG(header_edf, sinal, eventos)
            if (nargin == 3)
                this.header_edf = header_edf;
                this.sinal = sinal;
                this.eventos = eventos;
            end
        end
    end
    
end

