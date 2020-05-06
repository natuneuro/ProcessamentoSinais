from Modulos import LeituraArquivos, ProcessamentoDoSinal
import matplotlib.pyplot as plt
from scipy.signal import freqz
import numpy as np

sinal_eeg = LeituraArquivos.ImportarSinalEEG()

sinal_matriz = np.array([np.array(canal)
                         for canal in sinal_eeg.canais.values()])

tamanho_corte = 3

sinal_dividido = ProcessamentoDoSinal.dividir_sinal(
    sinal_matriz, tamanho_corte, sinal_eeg.frequencia_de_amostragem)


