from __future__ import absolute_import, division, print_function, unicode_literals
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
import numpy as np

# Criar rede feedforward semelhante à utilizada no código em matlab
# Organizar a rede como uma classe e criar modulo para treinar

# Configurando as camadas
model = tf.keras.Sequential()
model.add(layers.Dense(20, activation='sigmoid'))
model.add(layers.Dense(10))

# Configurando o treinamento
model.compile(optimizer=tf.keras.optimizers.SGD(0.01), loss='binary_crossentropy', metrics='Accuracy')

# Treinando a rede
data = np.random.random((1000, 32))
labels = np.random.random((1000, 1))

model.fit(data, labels, epochs=10, batch_size=32)
