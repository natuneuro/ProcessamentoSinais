class ImagemEntrada(object):
    imagem_delta_theta: list
    imagem_alpha_beta: list
    imagem_gama: list

    inicio_amostra = 0
    fim_amostra = 0

    ocorre_convulsao: bool

    def __init__(
        self,
        sinal_delta_theta,
        sinal_alpha_beta,
        sinal_gama,
        inicio_amostra,
        fim_amostra,
        conv,
    ):
        self.imagem_delta_theta = sinal_delta_theta
        self.imagem_alpha_beta = sinal_alpha_beta
        self.imagem_gama = sinal_gama
        self.inicio_amostra = inicio_amostra
        self.fim_amostra = fim_amostra
        self.ocorre_convulsao = conv
