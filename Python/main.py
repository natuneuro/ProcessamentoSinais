from Modulos import LeituraArquivos
from Modulos import WaveletEPsd
from Modulos import RedeNeural

sinal_eeg = LeituraArquivos.ImportarSinalEEG()

#  Associar trechos de sinal a eventos

feature_vector = WaveletEPsd.extrair_caracteristicas(sinal_eeg.canais, sinal_eeg.frequencia_de_amostragem)

acc = RedeNeural.treinamento_rna(feature_vector, )
