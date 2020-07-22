import numpy as np

from Classes import ImagemEntrada


def cria_imagens_saidas(gama_dividido, delta_theta_dividido, alpha_beta_dividido):

    imagens = []

    for i in range(0, len(gama_dividido)):
        imagens.append(
            ImagemEntrada.ImagemEntrada(
                delta_theta_dividido[i].sinal,
                alpha_beta_dividido[i].sinal,
                gama_dividido[i].sinal,
                gama_dividido[i].tempo_inicio,
                gama_dividido[i].tempo_final,
                gama_dividido[i].ocorre_conv,
            )
        )

    aux_1 = []
    aux_2 = []
    imagem_3c = []
    entrada_rede = []

    for i in range(0, len(imagens)):
        for j in range(0, 21):
            for k in range(0, len(delta_theta_dividido[0].sinal[0])):
                if j < 21:
                    aux_1.append(imagens[i].imagem_delta_theta[j][k])
                    aux_1.append(imagens[i].imagem_alpha_beta[j][k])
                    aux_1.append(imagens[i].imagem_gama[j][k])
                    # cria lista com os 3 valores de cada faixa
                    aux_2.append(aux_1)
                    # coloca essa lista na lista de listas
                    aux_1 = []
                    # limpa a lista auxiliar
                else:
                    aux_1 = [0, 0, 0]
                    aux_2.append(aux_1)
                    aux_1 = []
            imagem_3c.append(aux_2)
            # cria uma imagem
            aux_2 = []
            # limpa segundo auxiliar
        entrada_rede.append(imagem_3c)
        # cria a lista de imagens
        imagem_3c = []
        # limpa o auxiliar de imagens "3D"

    y = []

    for i in range(0, len(imagens)):
        y.append(imagens[i].ocorre_convulsao)

    entrada_rede = np.array(entrada_rede)
    y = np.array(y)

    return [entrada_rede, y]
