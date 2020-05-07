import numpy as np
import pywt
from scipy import signal


def extrair_caracteristicas(sinal, Fs):

    # Wavelet
    wavelet = pywt.Wavelet('db4')
    cA5, cD5, cD4, cD3, cD2, cD1 = pywt.wavedec(sinal, wavelet, mode='constant', level=5)

    # PSD (Power Spectrum Density)
    f, Pxx_den = signal.welch(sinal, Fs)

    feature_vector = [np.max([np.max(cA5), np.max(cD5), np.max(cD4), np.max(cD3), np.max(cD2), np.max(cD1)]),
                        np.min([np.min(cA5), np.min(cD5), np.min(cD4), np.min(cD3), np.min(cD2), np.min(cD1)]),
                        np.std([np.std(cA5), np.std(cD5), np.std(cD4), np.std(cD3), np.std(cD2), np.std(cD1)]),
                        np.mean([np.mean(cA5), np.mean(cD5), np.mean(cD4), np.mean(cD3), np.mean(cD2), np.mean(cD1)]),
                        np.max(Pxx_den), np.min(Pxx_den), np.mean(Pxx_den)]

    return feature_vector
