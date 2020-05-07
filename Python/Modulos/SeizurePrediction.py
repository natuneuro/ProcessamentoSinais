from Classes import TrechoSinal
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt
import numpy as np


def seizure_predict(sinal_dividido, eeg):
    pca = PCA()
    pca.fit(eeg)
    pca_data = pca.transform(eeg)

    per_var = np.round(pca.explained_variance_ratio_*100, decimals=1)
    labels = ['PC' + str(x) for x in range(1,len(per_var)+1)]

    plt.bar(x=range(1,len(per_var)+1), height=per_var, tick_label=labels)
    plt.ylabel('Percentage of Explained Varience')
    plt.xlabel('Principal Component')
    plt.title('Scree Plot')
    plt.show()
