from __future__ import absolute_import, division, print_function, unicode_literals
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
import numpy as np

# Criar rede feedforward semelhante à utilizada no código em matlab
# Organizar a rede como uma classe e criar modulo para treinar


def treinamento_rna(features, outputs):

    # Configurando as camadas

    model = tf.keras.Sequential([
        layers.Dense(10, activation='sigmoid'),
        layers.Dense(2)])

    # Configurando o treinamento

    model.compile(optimizer=tf.keras.optimizers.SGD(0.01, 0.9),
                loss=tf.keras.losses.MeanSquaredError(),
                metrics=['accuracy'])

    # Treinando a rede

    # data = np.random.randint(11, size=(1000, 4))
    # labels = np.random.random((1000, 1))

    # val_data = np.random.randint(11, size=(100, 4))
    # val_labels = np.random.random((100, 1))

    data = features
    labels = outputs

    hist = model.fit(data, labels, epochs=7000, batch_size=128)
    mean_acc = np.mean(hist.history['accuracy'])

    return mean_acc
