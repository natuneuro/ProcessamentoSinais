import sklearn.model_selection
import tensorflow as tf
from sklearn.metrics import confusion_matrix
from Classes import ImagemEntrada


def treina_rede(entradas: ImagemEntrada, saidas):

    # tf.keras.utils.normalize(entradas)

    X_train, X_test, y_train, y_test = sklearn.model_selection.train_test_split(
        entradas, saidas, test_size=0.30
    )

    model = tf.keras.models.load_model("meu_modelo")

    model.fit(
        X_train,
        y_train,
        batch_size=1,
        validation_data=(X_test, y_test),
        epochs=50,
        verbose=1,
    )

    # model.train_on_batch(entradas, saidas)

    model.save("meu_modelo")


def classifica_dados(entradas: ImagemEntrada, saidas):

    model = tf.keras.models.load_model("meu_modelo")

    # tf.keras.utils.normalize(entradas)

    predictions = (model.predict(entradas, batch_size=1, verbose=0) > 0.5).astype(
        "int32"
    )

    cm = confusion_matrix(saidas, predictions)

    return cm


def classifica_sem_saidass(entradas: ImagemEntrada):

    model = tf.keras.models.load_model("meu_modelo")

    predictions = (model.predict(entradas, batch_size=1, verbose=0) > 0.5).astype(
        "int32"
    )

    return predictions
