from Modulos import LeituraArquivos, ProcessamentoDoSinal, LeituraEventos, AssociaTrechoEvento
from Classes import ImagemEntrada
import matplotlib.pyplot as plt
from scipy.signal import freqz
import numpy as np
from sklearn.preprocessing import MinMaxScaler
import sklearn.model_selection
import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout, Activation, Flatten
from tensorflow.keras.layers import Conv2D, MaxPool2D


sinal_eeg = LeituraArquivos.ImportarSinalEEG()

eventos = LeituraEventos.importar_evento()

#sinal_matriz = np.array([np.array(canal)
#                         for canal in sinal_eeg.canais.values()])

tamanho_corte = 3
fs = sinal_eeg.frequencia_de_amostragem

print(fs)

#sinal_dividido = ProcessamentoDoSinal.dividir_sinal(
#    sinal_matriz, tamanho_corte, sinal_eeg.frequencia_de_amostragem)

#AssociaTrechoEvento.associa_trecho_evento(sinal_dividido, eventos)

#for i in range(0, len(sinal_dividido)):
#    if sinal_dividido[i].ocorre_conv:
#        print(i)

# fazer um loop para preencher a lista com as imagens de entrada

# filtrar o sinal nas faixas desejadas

sinal_delta_theta = sinal_eeg.decomporSinalEmFaixaDeFrequencia([1, 7])
sinal_alpha_beta = sinal_eeg.decomporSinalEmFaixaDeFrequencia([8, 30])
sinal_gama = sinal_eeg.decomporSinalEmFaixaDeFrequencia([31, 100])

# dividir sinais
delta_theta_dividido = ProcessamentoDoSinal.dividir_sinal(sinal_delta_theta, tamanho_corte, fs)
alpha_beta_dividido = ProcessamentoDoSinal.dividir_sinal(sinal_alpha_beta, tamanho_corte, fs)
gama_dividido = ProcessamentoDoSinal.dividir_sinal(sinal_gama, tamanho_corte, fs)

# associando os trechos aos eventos
AssociaTrechoEvento.associa_trecho_evento(delta_theta_dividido, eventos)
AssociaTrechoEvento.associa_trecho_evento(alpha_beta_dividido, eventos)
AssociaTrechoEvento.associa_trecho_evento(gama_dividido, eventos)

#plt.plot(delta_theta_dividido[0].sinal[0])
#plt.show()
#plt.plot(alpha_beta_dividido[0].sinal[0])
#plt.show()
#plt.plot(gama_dividido[0].sinal[0])
#plt.show()

#plt.imshow(gama_dividido[0].sinal)
#plt.show()

# preenchendo uma lista com imagens

imagens = []

for i in range(0, len(gama_dividido)):
    imagens.append(ImagemEntrada.ImagemEntrada(delta_theta_dividido[i].sinal, alpha_beta_dividido[i].sinal,
                                               gama_dividido[i].sinal, gama_dividido[i].tempo_inicio,
                                               gama_dividido[i].tempo_final, gama_dividido[i].ocorre_conv))

# para funcionar é necessário transformar os 3 sinais em uma matriz 3D

aux_1 = []
aux_2 = []
imagem_3c = []
entrada_rede = []

for i in range(0, len(imagens)):
    for j in range(0, 21):
        for k in range(0, len(imagens)):
            aux_1.append(imagens[i].imagem_delta_theta[j][k])
            aux_1.append(imagens[i].imagem_alpha_beta[j][k])
            aux_1.append(imagens[i].imagem_gama[j][k])
            # cria lista com os 3 valores de cada faixa
            aux_2.append(aux_1)
            # coloca essa lista na lista de listas
            aux_1 = []
            # limpa a lista auxiliar
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

y = np.array(y)

X = np.array(entrada_rede)

X = tf.keras.utils.normalize(X, axis=1)

print(X.shape)

print(y.shape)

print(X[0])

#plt.imshow(X[0])
#plt.show()

model = Sequential()

model.add(Conv2D(64,(3,3),input_shape=X.shape[1:]))
model.add(Activation("relu"))
model.add(MaxPool2D(pool_size=(2,2)))

model.add(Conv2D(64,(3,3)))
model.add(Activation("relu"))
model.add(MaxPool2D(pool_size=(2,2)))

model.add(Flatten())

model.add(Dense(64))
model.add(Activation('relu'))

model.add(Dense(1))
model.add(Activation('sigmoid'))

model.compile(loss="binary_crossentropy",
              optimizer="adam",
              metrics=['accuracy'])

X_train, X_test, y_train, y_test = sklearn.model_selection.train_test_split(X, y, test_size=0.3)

print(X_train.shape)

model.fit(X_train, y_train, validation_data=(X_test, y_test), epochs=10)
