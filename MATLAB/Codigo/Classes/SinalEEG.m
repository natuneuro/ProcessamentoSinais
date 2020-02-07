classdef SinalEEG
%   Estrutura de dados que representa o sinal do EEG, junto com 
%   informações importantes
    
    properties
        header_edf
        frequencia_de_amostragem
        sinal
        eventos
        
        canais = containers.Map(...
            {'FP1', 'FP2', 'F7',...
             'F3', 'FZ', 'F4',  ...
             'F8', 'A1', 'T3',  ...
             'C3', 'CZ', 'C4',  ...
             'T4', 'A2', 'T5',  ...
             'P3', 'PZ', 'P4',  ...
             'T6', 'O1', 'O2'}, ...
            {[], [], [],        ...
             [], [], [],        ...
             [], [], [],        ...
             [], [], [],        ...
             [], [], [],        ...
             [], [], [],        ...
             [], [], []})
         
         canais_delta_theta
         canais_alfa_beta
         canais_gama
    end
    
    methods
        % Contrutor da classe
        function this = SinalEEG(header_edf, sinal, eventos)
            if (nargin == 3)
                this.header_edf = header_edf;
                this.frequencia_de_amostragem = this.header_edf.frequency(1);
                
                this.sinal = sinal;
                this.eventos = eventos;
                
                this.canais_delta_theta = this.canais;
                this.canais_alfa_beta = this.canais;
                this.canais_gama = this.canais;
                this.CarregarSinalDeCadaCanal();
            end
        end
        
        function CarregarSinalDeCadaCanal(this)
            canais_presentes_no_sinal = this.header_edf.label;
            nomes_canais = keys(this.canais);
            
            for i = 1:length(canais_presentes_no_sinal)
                sinal_do_canal = this.sinal(i, :);
                
                label_do_canal = erase(canais_presentes_no_sinal{i}, ["EEG" "REF"]);
                
                contem_label_indicado = contains(label_do_canal, nomes_canais);
                
                if(contem_label_indicado)
                    this.canais(label_do_canal) = sinal_do_canal;
                end
            end
        end
        
        function sinal_filtrado = DecomporSinalEmFaixaDeFrequencia(this, faixa_de_frequencia)
            sinal_filtrado = bandpass(values(this.canais), faixa_de_frequencia, this.frequencia_de_amostragem);
        end
    end
    
end

