import matplotlib.pyplot as plt
import math
import numpy as np


def grafico_sobreposicao(sinal, gama_dividido, fs, ax):
    for i in range(0, len(gama_dividido)):
        if gama_dividido[i].ocorre_conv:
            inicio = math.floor(gama_dividido[i].tempo_inicio * fs)
            fim = math.floor(gama_dividido[i].tempo_final * fs)
            ax.plot(
                range(inicio, fim),
                sinal[inicio:fim],
                color="r",
                # label="Convulsão",
                linewidth=1,
            )
            plt.legend(loc=0)


def grafico_area(predictions, gama_dividido, fs, ax):
    for i in range(0, len(predictions)):
        if predictions[i] == 1:
            inicio = math.floor(gama_dividido[i].tempo_inicio * fs)
            fim = math.floor(gama_dividido[i].tempo_final * fs)
            ax.axvspan(inicio, fim, alpha=0.3, color="g")


def faz_graficos(sinal_eeg, canal, gama_dividido, predictions, fs):
    sinal = np.array(sinal_eeg.canais[canal])

    predictions = np.array(predictions)

    plt.style.use("fivethirtyeight")

    fig, ax = plt.subplots()

    grafico_sobreposicao(sinal, gama_dividido, fs, ax)

    grafico_area(predictions, gama_dividido, fs, ax)

    plt.show()
