import sys
import matplotlib.pyplot as plt
from sklearn import preprocessing
import numpy as np
from PIL import Image
import tensorflow as tf
import math

from Modulos import (
    CNN,
    AssociaTrechoEvento,
    ConfusionMatrix,
    CriaImagen,
    LeituraArquivos,
    LeituraEventos,
    ProcessamentoDoSinal,
    CriaRede,
    UsaRede,
    graficos,
)

# CriaRede.cria_modelo()

sinal_eeg = LeituraArquivos.ImportarSinalEEG()

eventos = LeituraEventos.importar_evento()

fs = sinal_eeg.frequencia_de_amostragem

sinal_delta_theta = sinal_eeg.decomporSinalEmFaixaDeFrequencia([1, 7])
sinal_alpha_beta = sinal_eeg.decomporSinalEmFaixaDeFrequencia([8, 30])
sinal_gama = sinal_eeg.decomporSinalEmFaixaDeFrequencia([31, 100])

delta_theta_dividido = ProcessamentoDoSinal.dividir_sinal(sinal_delta_theta, fs)
alpha_beta_dividido = ProcessamentoDoSinal.dividir_sinal(sinal_alpha_beta, fs)
gama_dividido = ProcessamentoDoSinal.dividir_sinal(sinal_gama, fs)

AssociaTrechoEvento.associa_trecho_evento(delta_theta_dividido, eventos)
AssociaTrechoEvento.associa_trecho_evento(alpha_beta_dividido, eventos)
AssociaTrechoEvento.associa_trecho_evento(gama_dividido, eventos)

dados = CriaImagen.cria_imagens_saidas(
    gama_dividido, delta_theta_dividido, alpha_beta_dividido
)

fft_imagens = []

for i in range(0, len(dados[0])):
    fft = np.fft.fftn(dados[0][i])
    fft = np.log(np.abs(np.fft.fftshift(fft) ** 2))
    img_fft = tf.keras.preprocessing.image.array_to_img(fft)
    array_fft = tf.keras.preprocessing.image.img_to_array(img_fft)
    array_fft = array_fft * (1.0 / 255)
    fft_imagens.append(array_fft)

fft_imagens = np.array(fft_imagens)

# UsaRede.treina_rede(fft_imagens, dados[1])

# cm = UsaRede.classifica_dados(fft_imagens, dados[1])

predictions = UsaRede.classifica_sem_saidas(fft_imagens)

# cm_plot_labels = ["Normal", "Epilepsy"]
# ConfusionMatrix.plot_confusion_matrix(cm, cm_plot_labels, title="Confusion Matrix")

sinal = np.array(sinal_eeg.canais["FP1"])

predictions = np.array(predictions)

plt.style.use("fivethirtyeight")

fig, ax = plt.subplots()

ax.plot(sinal_eeg.canais["FP1"], linewidth=1, label="Normal")

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


for i in range(0, len(predictions)):
    if predictions[i] == 1:
        inicio = math.floor(gama_dividido[i].tempo_inicio * fs)
        fim = math.floor(gama_dividido[i].tempo_final * fs)
        ax.axvspan(inicio, fim, alpha=0.3, color="g")


plt.show()

# Colocar o eixo x em segundos. E fazer para os outros canais usando a ideia de cada canal em uma janela do programa, deixando o usuário escolher.
