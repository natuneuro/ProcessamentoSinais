from Classes import TrechoSinal
import math


def dividir_sinal(sinal, tamanho_do_corte, fs):

    comprimento_sinal = len(sinal)
    numero_amostras_tempo = math.floor(tamanho_do_corte/(1/fs))
    quantidade_intervalos = math.ceil(comprimento_sinal/numero_amostras_tempo)

    inicio = 1
    final = numero_amostras_tempo

    # Lista encadeada ao invés de cells
    sinal_dividido = []

    trecho_sinal = TrechoSinal.TrechoSinal(sinal[0:(final-1)], 0, numero_amostras_tempo*(1/fs))

    sinal_dividido.append(trecho_sinal)

    for i in range(2, quantidade_intervalos):
        inicio = final + 1
        final = i*numero_amostras_tempo

        if final > comprimento_sinal:
            trecho_sinal = TrechoSinal.TrechoSinal(sinal[(inicio-1):(len(sinal)-1)], inicio*(1/fs), len(sinal)*(1/fs))
            sinal_dividido.append(trecho_sinal)

        else:
            trecho_sinal = TrechoSinal.TrechoSinal(sinal[(inicio-1):(final-1)], inicio*(1/fs), final*(1/fs))
            sinal_dividido.append(trecho_sinal)

    return sinal_dividido
