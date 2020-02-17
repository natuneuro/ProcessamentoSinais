classdef SinalEEG
%   Estrutura de dados que representa o sinal do EEG, junto com 
%   informações importantes.
    
    properties
        header_edf % Cabecalho de informacoes do EEG
        frequencia_de_amostragem 
        sinal
        eventos % Struct que contem a informacao do nome do evento e o intervalo de inicio e fim
         
        canais_delta_theta % Dicionario que possui o sinal com os 21 canais do padrao 10-20 com frequencias amostradas na faixa de [1 - 7Hz]
        canais_alpha_beta % Dicionario que possui o sinal com os 21 canais do padrao 10-20 com frequencias amostradas na faixa de [8 - 30Hz]
        canais_gama % Dicionario que possui o sinal com os 21 canais do padrao 10-20 com frequencias amostradas na faixa de [31 - 100Hz]

        canais % Dicionario com os 21 canais do padrao 10-20
    end
    
    methods
        % Contrutor da classe
        function this = SinalEEG(header_edf, sinal, eventos)
            if (nargin == 3)
                this.header_edf = header_edf;
                this.frequencia_de_amostragem = this.header_edf.frequency(1);
                
                this.sinal = sinal;
                this.eventos = eventos;
                
                this.canais = containers.Map(...
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
                     [], [], []});
                 
                this.canais_delta_theta = this.canais;
                this.canais_alpha_beta = this.canais;
                this.canais_gama = this.canais;
                this.CarregarSinalDeCadaCanal();
            end
        end
        
        function CarregarSinalDeCadaCanal(this)
        % Funcao que verifica a existencia de cada canal e atribui no 
        % dicionario de canais todos os canais do padrao 10-20 a partir 
        % dos canais presentes no exame
            
            canais_presentes_no_sinal = this.header_edf.label;
            nomes_canais = keys(this.canais);
            
            for i = 1:length(canais_presentes_no_sinal)
                sinal_do_canal = this.sinal(i, :);
                
                label_do_canal = erase(canais_presentes_no_sinal{i}, ["EEG" "REF" "LE" "DC"]);
                
                contem_label_indicado = contains(label_do_canal, nomes_canais);
                
                if(contem_label_indicado)
                    this.canais(label_do_canal) = sinal_do_canal;
                end
            end
        end
        
        function sinal_filtrado = DecomporSinalEmFaixaDeFrequencia(this, faixa_de_frequencia)
            sinal_a_ser_filtrado = transpose(values(this.canais));
            sinal_a_ser_filtrado = transpose(cell2mat(sinal_a_ser_filtrado));
            
            sinal_filtrado = transpose(bandpass(sinal_a_ser_filtrado, faixa_de_frequencia, this.frequencia_de_amostragem));
        end
        
        function AtribuirSinaisDasFrequenciasDeInteresse(this, sinal_delta_theta, sinal_alpha_beta, sinal_gama)    
            
            labels_canais = keys(this.canais);           
            
            for i = 1:size(labels_canais, 2)
                this.canais_delta_theta(labels_canais{i}) = sinal_delta_theta(i, :);
                this.canais_alpha_beta(labels_canais{i}) = sinal_alpha_beta(i, :);
                this.canais_gama(labels_canais{i}) = sinal_gama(i, :);
            end
        end
    end
    
end

