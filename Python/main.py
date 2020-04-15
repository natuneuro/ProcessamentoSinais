from Modulos import LeituraArquivos
from Modulos import WaveletEPsd
from Modulos import RedeNeural
from Modulos import DividirSinal
from Modulos import LeituraEventos
from Modulos import AssociaTrechoEvento
import numpy as np
import matplotlib.pyplot as plt
from sklearn.metrics import confusion_matrix
import itertools
import seaborn as sns

# Selecionando base de dados para o treinamento da rede

sinal_eeg = LeituraArquivos.ImportarSinalEEG()

eventos = LeituraEventos.importar_evento()

sinal_eeg_2 = sinal_eeg.canais["Fp1"]

sinal_div = DividirSinal.dividir_sinal(sinal_eeg_2, 3, sinal_eeg.frequencia_de_amostragem)

AssociaTrechoEvento.associa_trecho_evento(sinal_div, eventos)

feature_vec = []

for i in range(0, len(sinal_div)):
    feature_vec.append(WaveletEPsd.extrair_caracteristicas(sinal_div[i].sinal, sinal_eeg.frequencia_de_amostragem))

saidas_trechos = []

for i in range(0, len(sinal_div)):
    saidas_trechos.append(sinal_div[i].ocorre_conv)

rede = RedeNeural.treinamento_rna(feature_vec, saidas_trechos)

# Utilizando outra base de dados para testar a rede

sinal_eeg = LeituraArquivos.ImportarSinalEEG()

eventos = LeituraEventos.importar_evento()

sinal_eeg_2 = sinal_eeg.canais["Fp1"]

sinal_div = DividirSinal.dividir_sinal(sinal_eeg_2, 3, sinal_eeg.frequencia_de_amostragem)

AssociaTrechoEvento.associa_trecho_evento(sinal_div, eventos)

feature_vec = []

for i in range(0, len(sinal_div)):
    feature_vec.append(WaveletEPsd.extrair_caracteristicas(sinal_div[i].sinal, sinal_eeg.frequencia_de_amostragem))

saidas_trechos = []

for i in range(0, len(sinal_div)):
    saidas_trechos.append(sinal_div[i].ocorre_conv)

rounded_predictions = RedeNeural.predic_rna(rede, feature_vec, saidas_trechos)

cm = confusion_matrix(saidas_trechos, rounded_predictions)
cm_plot_labels = ['Normal', 'Convulsão']

sns.heatmap(cm, annot=True, fmt='.5g', cmap="Blues")
plt.show()

# A rede apresenta resultados satisfatórios ao classificar dados desconhecidos. Algumas bases de dados não tem
# bom resultado, tentar outras técnicas de aquisição de características, PCA por exemplo, e ajustes na arquitetura da rede
