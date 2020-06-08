from Classes import SinalDividido, ImagemEntrada
from scipy.signal import butter, freqz, filtfilt
import numpy as np
import math


def butter_bandpass(lowcut, highcut, fs, order):
    nyq = 0.5 * fs
    low = lowcut / nyq
    high = highcut / nyq
    b, a = butter(order, [low, high], btype='band')
    return b, a


def butter_bandpass_filter(data, lowcut, highcut, fs, order=5):
    b, a = butter_bandpass(lowcut, highcut, fs, order=order)
    y = filtfilt(b, a, data)
    return y


def dividir_sinal(sinal, tamanho_do_corte, frequencia_sinal):
    comprimento_sinal = len(sinal[0])

    quantidade_amostras_por_intervalo = math.floor(tamanho_do_corte/(1/frequencia_sinal))

    quantidade_intervalos = math.ceil(
        comprimento_sinal / quantidade_amostras_por_intervalo)

    inicio = 1
    final = quantidade_amostras_por_intervalo

    trechos_sinal = []

    trecho = SinalDividido.SinalDividido(np.array(sinal[:, (inicio - 1):(final - 1)]),
                                         0, quantidade_amostras_por_intervalo*(1/frequencia_sinal))

    trechos_sinal.append(trecho)

    for i in range(2, quantidade_intervalos + 1):
        inicio = final + 1
        final = i*quantidade_amostras_por_intervalo

        if final > comprimento_sinal:
            trecho = SinalDividido.SinalDividido(np.array(sinal[:, (inicio - 1):(final - 1)]), inicio * (
                1 / frequencia_sinal), len(sinal[0])*(1 / frequencia_sinal))

            trechos_sinal.append(trecho)
        else:
            trecho = SinalDividido.SinalDividido(np.array(sinal[:, (inicio - 1):(final - 1)]), inicio * (
                1 / frequencia_sinal), final*(1 / frequencia_sinal))

            trechos_sinal.append(trecho)

    return trechos_sinal


def criar_imagens_entrada(sinais_divididos_delta_theta, sinais_divididos_alpha_beta, sinais_divididos_gama):
    quantidade_imagens = len(sinais_divididos_delta_theta)
    imagens = []

    for i in range(quantidade_imagens):
        inicio_amostra = sinais_divididos_delta_theta[i].tempo_inicio
        fim_amostra = sinais_divididos_delta_theta[i].tempo_final

        imagens.append(ImagemEntrada.ImagemEntrada(sinais_divididos_delta_theta,
                                                   sinais_divididos_alpha_beta, sinais_divididos_gama, inicio_amostra, fim_amostra))

    return imagens
