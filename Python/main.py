from Modulos import LeituraArquivos
from Modulos import ProcessamentoDoSinal
from Modulos import WaveletEPsd
from Modulos import RedeNeural
from Modulos import DividirSinal
from Modulos import LeituraEventos
from Modulos import AssociaTrechoEvento
from Modulos import SeizurePrediction
from sklearn.decomposition import PCA
from sklearn import preprocessing
import numpy as np
import matplotlib.pyplot as plt
from operator import itemgetter


# Data Standardization funcionou de maneira bastante satisfatória, melhorando significativamente
# a acurácia da rede neural

# Selecionando base de dados para o treinamento da rede

sinal_eeg = LeituraArquivos.ImportarSinalEEG()

eventos = LeituraEventos.importar_evento()

sinal_eeg_2 = sinal_eeg.canais['Fp1']

sinal_eeg_2 = ProcessamentoDoSinal.butter_bandpass_filter(sinal_eeg_2,1,60,sinal_eeg.frequencia_de_amostragem,6)

sinal_div = DividirSinal.dividir_sinal(sinal_eeg_2, 3, sinal_eeg.frequencia_de_amostragem)

AssociaTrechoEvento.associa_trecho_evento(sinal_div, eventos)

for i in range(0, len(sinal_div)):
    if sinal_div[i].ocorre_conv:
        print(i)

#array_test = []

#for i in range(0, 10):
    #array_test.extend(sinal_div[i].sinal)

#plt.plot(array_test,linewidth=0.3)
#plt.show()

feature_vec = []

for i in range(0, len(sinal_div)):
    feature_vec.append(WaveletEPsd.extrair_caracteristicas(sinal_div[i].sinal, sinal_eeg.frequencia_de_amostragem))

saidas_trechos = []

for i in range(0, len(sinal_div)):
    saidas_trechos.append(sinal_div[i].ocorre_conv)

# Teste PCA

feature_vec = preprocessing.scale(feature_vec)

pca = PCA()
pca.fit(feature_vec)
pca_data = pca.transform(feature_vec)

# Valor das PCs 1 e 2 para todos os trechos do sinal
#print(pca_data[:,0:2])

# Plotagem do gráfico de variância das PCs
#per_var = np.round(pca.explained_variance_ratio_*100, decimals=1)
#labels = ['PC' + str(x) for x in range (1,len(per_var)+1)]

#plt.bar(x=range(1,len(per_var)+1), height=per_var, tick_label=labels)
#plt.ylabel('Percentage of Explained Varience')
#plt.xlabel('Principal Component')
#plt.title('Scree Plot')
#plt.show()

saidas_trechos = np.asarray(saidas_trechos)

#rede = RedeNeural.treinamento_rna(pca_data[:,0:2], saidas_trechos)

rede = RedeNeural.treinamento_rna(feature_vec, saidas_trechos)

# Utilizando outra base de dados para testar a rede (não tem um bom desempenho)

#sinal_eeg = LeituraArquivos.ImportarSinalEEG()

#eventos = LeituraEventos.importar_evento()

#sinal_eeg_2 = sinal_eeg.canais["Fp1"]

# Teste com sinal padronizado

#sinal_eeg_2 = preprocessing.scale(sinal_eeg_2)

#sinal_div = DividirSinal.dividir_sinal(sinal_eeg_2, 3, sinal_eeg.frequencia_de_amostragem)

#AssociaTrechoEvento.associa_trecho_evento(sinal_div, eventos)

#feature_vec = []

#for i in range(0, len(sinal_div)):
    #feature_vec.append(WaveletEPsd.extrair_caracteristicas(sinal_div[i].sinal, sinal_eeg.frequencia_de_amostragem))

#saidas_trechos = []

#for i in range(0, len(sinal_div)):
    #saidas_trechos.append(sinal_div[i].ocorre_conv)

# Teste PCA

#scaled_data = preprocessing.scale(feature_vec)

#pca = PCA()
#pca.fit(scaled_data)
#pca_data = pca.score_samples(scaled_data)

#saidas_trechos = np.asarray(saidas_trechos)

#rounded_predictions = RedeNeural.predic_rna(rede, feature_vec)

#cm = confusion_matrix(saidas_trechos, rounded_predictions)
#cm_plot_labels = ['Normal', 'Convulsão']

#sns.heatmap(cm, annot=True, fmt='.5g', cmap="Blues")
#plt.show()
