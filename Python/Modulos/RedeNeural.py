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


def treinamento_rna(data, labels):
    # Configurando as camadas

    model = tf.keras.Sequential([
        layers.Dense(16, input_shape=(7,), activation='sigmoid'),
        layers.Dense(2, activation='softmax')])

    model.summary()

    # Configurando o treinamento

    model.compile(optimizer=tf.keras.optimizers.SGD(learning_rate=0.01, momentum=0.9),
                  loss='sparse_categorical_crossentropy',
                  metrics=['accuracy'])

    X_train, X_test, y_train, y_test = sklearn.model_selection.train_test_split(data, labels, test_size=0.3)

    # Treinando a rede e validando a rede

    model.fit(X_train, y_train, validation_data=(X_test, y_test),batch_size=32, epochs=7000, shuffle=True, verbose=2)

    # Matriz de confusão

    rounded_predictions = predic_rna(model, data)

    cm = confusion_matrix(labels, rounded_predictions)
    cm_plot_labels = ['Normal', 'Epilepsia']

    plot_confusion_matrix(cm, cm_plot_labels, title='Confusion Matrix')

    return model


def predic_rna(model, data):
    # Configurando modelo de predição para outros dados

    rounded_predictions = model.predict_classes(data, batch_size=32, verbose=0)

    return rounded_predictions


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
