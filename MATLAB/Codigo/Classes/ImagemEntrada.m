classdef ImagemEntrada
    % Classe de imagem para ser usada como entrada para a rede 
    % convolucional, e visualizar como ela está sendo exibida
    
    properties
        imagem_delta_theta
        imagem_alpha_beta
        imagem_gama
        
        inicio_amostra
        fim_amostra
        
        ocorre_convulsao
    end
    
    methods
        function this = ImagemEntrada(sinal_delta_theta, sinal_alpha_beta, sinal_gama, inicio_amostra, fim_amostra)
            % Construtor da classe
            
            this.imagem_delta_theta = sinal_delta_theta.sinal;
            this.imagem_alpha_beta = sinal_alpha_beta.sinal;
            this.imagem_gama = sinal_gama.sinal;
            this.inicio_amostra = inicio_amostra;
            this.fim_amostra = fim_amostra;
        end
        
        function PlotarRepresentacao(input)
        end
    end
end

