from Modulos import ConfusionMatrix
import sklearn.model_selection
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout, Activation, Flatten
from tensorflow.keras.layers import Conv2D, MaxPool2D
from sklearn.metrics import confusion_matrix


def CNN_fit(imagens, saidas):

    X_train, X_test, y_train, y_test = sklearn.model_selection.train_test_split(imagens, saidas, test_size=0.30)

    model = Sequential()

    model.add(Conv2D(64,kernel_size=(3,3), strides=(1,1), input_shape=imagens.shape[1:]))
    model.add(Activation("relu"))
    model.add(MaxPool2D(pool_size=(2,2)))

    model.add(Conv2D(64,kernel_size=(3,3), strides=(1,1)))
    model.add(Activation("relu"))
    model.add(MaxPool2D(pool_size=(2,2)))

    model.add(Flatten())

    model.add(Dense(64))
    model.add(Activation('relu'))

    model.add(Dense(1))
    model.add(Activation('sigmoid'))

    model.compile(tf.keras.optimizers.SGD(learning_rate=0.0003, momentum=0.09),
                  loss="binary_crossentropy", metrics=['accuracy'])

    model.fit(X_train, y_train, batch_size=32, validation_data=(X_test, y_test), epochs=50, verbose=1)

    predictions = (model.predict(imagens, batch_size=32, verbose=0) > 0.5).astype("int32")

    cm = confusion_matrix(saidas, predictions)
    
    #---- Classification Accuracy  ---------
    TP=cm[1][1]
    TN=cm[0][0]
    FP=cm[1][0]
    FN=cm[0][1]

    accuracy=(TP+TN)/(TP+FP+TN+FN)
    print("accuracy: ",accuracy)

    #recall=TP/(TP+FN)
    #print("recall: ",recall)

    precision=TP/(TP+FP)
    print("precision: ", precision)

    #f_score=2*(precision*recall)/(precision+recall)
    #print("f-score: ", f_score)

    cm_plot_labels = ['Normal', 'Epilepsy']
    ConfusionMatrix.plot_confusion_matrix(cm, cm_plot_labels, title='Confusion Matrix')
