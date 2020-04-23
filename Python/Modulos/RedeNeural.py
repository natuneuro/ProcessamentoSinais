from __future__ import absolute_import, division, print_function, unicode_literals
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
import numpy as np
import sklearn.model_selection
from sklearn.metrics import plot_confusion_matrix
from sklearn.metrics import confusion_matrix
import itertools
import matplotlib.pyplot as plt
import seaborn as sns


def treinamento_rna(data, labels):
    # Configurando as camadas

    model = tf.keras.Sequential([
        layers.Dense(16, input_shape=(4,), activation='sigmoid'),
        layers.Dense(2, activation='softmax')])

    model.summary()

    # Configurando o treinamento

    model.compile(optimizer=tf.keras.optimizers.SGD(0.01, 0.9),
                  loss='sparse_categorical_crossentropy',
                  metrics=['accuracy'])

    X_train, X_test, y_train, y_test = sklearn.model_selection.train_test_split(data, labels, test_size=0.3, random_state=3)

    # Treinando a rede e validando a rede

    model.fit(X_train, y_train, validation_data=(X_test, y_test),batch_size=32, epochs=4000, shuffle=True, verbose=2)

    # Plotando a matriz de confusão do treinamento/validação

    #disp = plot_confusion_matrix(model, X_test, y_test,
                                 #display_labels=("Convulsão", "Normal"),
                                 #cmap="Blues",
                                 #normalize="normalize")

    #print(disp.confusion_matrix)
    #plt.show()

    return model


def predic_rna(model, data):
    # Configurando modelo de predição para outros dados

    rounded_predictions = model.predict_classes(data, batch_size=32, verbose=0)

    return rounded_predictions
