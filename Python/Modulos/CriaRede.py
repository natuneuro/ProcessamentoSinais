import tensorflow as tf
from tensorflow.keras.layers import (
    Activation,
    Conv2D,
    Dense,
    Flatten,
    MaxPool2D,
    GlobalMaxPooling2D,
)
from tensorflow.keras.models import Sequential


def cria_modelo():
    model = Sequential()

    model.add(
        Conv2D(128, kernel_size=(3, 3), strides=(1, 1), input_shape=(None, None, 3))
    )
    model.add(Activation("relu"))
    model.add(MaxPool2D(pool_size=(2, 2)))

    model.add(Conv2D(64, kernel_size=(3, 3), strides=(1, 1)))
    model.add(Activation("relu"))
    model.add(MaxPool2D(pool_size=(2, 2)))

    model.add(GlobalMaxPooling2D())

    model.add(Flatten())

    model.add(Dense(64))
    model.add(Activation("relu"))

    model.add(Dense(32))
    model.add(Activation("relu"))

    model.add(Dense(1))
    model.add(Activation("sigmoid"))

    model.compile(
        tf.keras.optimizers.Adam(learning_rate=0.0001),
        loss="binary_crossentropy",
        metrics=["accuracy"],
    )

    model.save("meu_modelo")
