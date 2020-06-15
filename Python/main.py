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
from tensorflow.keras.layers import Convolution2D
from tensorflow.keras.callbacks import TensorBoard
import tensorflow.keras.optimizers
import tensorflow.keras.applications
from sklearn.metrics import confusion_matrix
import itertools
import math
import time


def plot_confusion_matrix(cm, classes, normalize=False, title='Confusion Matix', cmap=plt.cm.Blues):

    plt.imshow(cm, interpolation='nearest', cmap=cmap)
    plt.title(title)
    plt.colorbar()
    tick_marks = np.arange(len(classes))
    plt.xticks(tick_marks, classes, rotation=45)
    plt.yticks(tick_marks, classes)

    if normalize:
        cm = cm.astype('float') / cm.sum(axis=1)[:,np.newaxis]
        print("Normalized Confusion Matrix")
    else:
        print("Confusion Matrix")

    print(cm)

    thresh = cm.max()/2
    for i,j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
        plt.text(j,i,cm[i,j],
                horizontalalignment="center",
                color="white" if cm[i,j] > thresh else "black")

    plt.tight_layout()
    plt.ylabel('True label')
    plt.xlabel('Predicted label')
    plt.show()


sinal_eeg = LeituraArquivos.ImportarSinalEEG()

eventos = LeituraEventos.importar_evento()

#sinal_matriz = np.array([np.array(canal)
#                         for canal in sinal_eeg.canais.values()])

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

delta_theta_dividido = ProcessamentoDoSinal.dividir_sinal(sinal_delta_theta, fs)
alpha_beta_dividido = ProcessamentoDoSinal.dividir_sinal(sinal_alpha_beta, fs)
gama_dividido = ProcessamentoDoSinal.dividir_sinal(sinal_gama, fs)

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

aux_1 = []
aux_2 = []
imagem_3c = []
entrada_rede = []

for i in range(0, len(imagens)):
    for j in range(0, 224):
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
                aux_1 = [0,0,0]
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

y = np.array(y)

X = np.array(entrada_rede)

print(X.shape)

print(y.shape)

#print(X[0])

#plt.imshow(X[0])
#plt.show()

vgg16_model = tf.keras.applications.vgg16.VGG16()

# necessário redimensionar as imagens para 224x224x3

model = Sequential()
for layer in vgg16_model.layers:
    model.add(layer)

model.layers.pop()

for layer in model.layers:
    layer.trainable = False

model.add(Dense(1, activation='sigmoid'))

model.compile(tf.keras.optimizers.Adam(learning_rate=.0001),
              loss='binary_crossentropy',
              metrics=['accuracy'])

X_train, X_test, y_train, y_test = sklearn.model_selection.train_test_split(X, y, test_size=0.15)

X_train = tf.keras.utils.normalize(X_train, axis=1)
X_test = tf.keras.utils.normalize(X_test, axis=1)

batch = math.floor(len(X))

model.fit(X_train, y_train, batch_size=64, epochs=20, validation_data=(X_test, y_test))

#model = Sequential()

#model.add(Conv2D(64,kernel_size=(3,3), strides=(1,1), input_shape=X.shape[1:]))
#model.add(Activation("relu"))
#model.add(MaxPool2D(pool_size=(2,2)))

#model.add(Conv2D(64,kernel_size=(3,3), strides=(1,1)))
#model.add(Activation("relu"))
#model.add(MaxPool2D(pool_size=(2,2)))

#model.add(Flatten())

#model.add(Dense(64))
#model.add(Activation('relu'))

#model.add(Dense(1))
#model.add(Activation('sigmoid'))

#model.compile(tf.keras.optimizers.SGD(learning_rate=0.0003, momentum=0.9), loss="binary_crossentropy", metrics=['accuracy'])

#X_train, X_test, y_train, y_test = sklearn.model_selection.train_test_split(X, y, test_size=0.3)

#print(X_train.shape)
#print(X_test.shape)

#model.fit(X_train, y_train, batch_size=32, validation_data=(X_test, y_test), epochs=20, verbose=2)

predictions = (model.predict(X, batch_size=64, verbose=0) > 0.5).astype("int32")

cm = confusion_matrix(y, predictions)
cm_plot_labels = ['Normal', 'Epilepsia']
plot_confusion_matrix(cm, cm_plot_labels, title='Confusion Matrix')
