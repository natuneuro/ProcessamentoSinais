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

# plt.imshow(dados[0][10])
# plt.show()

# rgb_imagens = []

# for i in range(0, len(dados[0])):
# img_rgb = tf.keras.preprocessing.image.array_to_img(dados[0][i])
# array_rgb = tf.keras.preprocessing.image.img_to_array(img_rgb)
# array_rgb = array_rgb * (1.0 / 255)
# rgb_imagens.append(array_rgb)

# rgb_imagens = np.array(rgb_imagens)

fft_imagens = []

for i in range(0, len(dados[0])):
    fft = np.fft.fftn(dados[0][i])
    fft = np.log(np.abs(np.fft.fftshift(fft) ** 2))
    img_fft = tf.keras.preprocessing.image.array_to_img(fft)
    array_fft = tf.keras.preprocessing.image.img_to_array(img_fft)
    array_fft = array_fft * (1.0 / 255)
    fft_imagens.append(array_fft)

fft_imagens = np.array(fft_imagens)

# plt.imshow(fft_imagens[16])
# plt.show()

# print(np.min(fft_imagens[0]))

# classification_info = CNN.CNN_fit(fft_imagens, dados[1])

# classification_info = CNN.CNN_fit(dados[0], dados[1])

# classification_info = CNN.CNN_fit(rgb_imagens, dados[1])

# classification_info é um array com a estrutura [accuracy, precision, cm]

# print("\nAccuracy:")
# print(classification_info[0])

# print("\nPrecision:")
# print(classification_info[1])

# cm_plot_labels = ["Normal", "Epilepsy"]
# ConfusionMatrix.plot_confusion_matrix(
# classification_info[2], cm_plot_labels, title="Confusion Matrix"
# )

# UsaRede.treina_rede(fft_imagens, dados[1])

# cm = UsaRede.classifica_dados(fft_imagens, dados[1])

# cm_plot_labels = ["Normal", "Epilepsy"]
# ConfusionMatrix.plot_confusion_matrix(cm, cm_plot_labels, title="Confusion Matrix")

# sinal_eeg = np.array(sinal_eeg)

# modificação que faz com que os intervalos onde acontece convulsão sejam marcados em vermelho
# no gráfico. Utiliza só um canal. Não fiquei satisfeito, achei bem mais ou menos, porém é mais
# fácil do que marcar o fazer o plot do intervalo em outra cor. Vou fazer a modificação para
# plotar em outra cor, mas por enquanto só consegui fazer essa.

fig, ax = plt.subplots()

ax.plot(sinal_eeg.canais["FP1"], linewidth=1, label="EEG Normal")
for i in range(0, len(gama_dividido)):
    if gama_dividido[i].ocorre_conv:
        inicio = math.floor(gama_dividido[i].tempo_inicio * fs)
        fim = math.floor(gama_dividido[i].tempo_final * fs)
        ax.axvspan(inicio, fim, alpha=0.5, color="r")


plt.show()
