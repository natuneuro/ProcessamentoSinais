from __future__ import absolute_import, division, print_function, unicode_literals
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
import numpy as np

# Criar rede feedforward semelhante à utilizada no código em matlab
# Organizar a rede como uma classe e criar modulo para treinar

# Configurando as camadas
model = tf.keras.Sequential([
    layers.Dense(20, activation='sigmoid'),
    layers.Dense(2)])

# Configurando o treinamento
model.compile(optimizer=tf.keras.optimizers.SGD(0.01, 0.9),
              loss=tf.keras.losses.MeanSquaredError(),
              metrics=['accuracy'])

# Treinando a rede
data = np.random.randint(101, size=(1000, 5))
labels = np.random.random((1000, 1))

val_data = np.random.randint(101, size=(100, 5))
val_labels = np.random.random((100, 1))

hist = model.fit(data, labels, epochs=1000, batch_size=128, validation_data=(val_data, val_labels))

# Acurácia média
print(np.mean(hist.history['accuracy']))
