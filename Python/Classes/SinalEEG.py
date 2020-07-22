import numpy as np
from pyedflib import edfreader
from sklearn import preprocessing

from Modulos import ProcessamentoDoSinal


class SinalEEG(object):
    frequencia_de_amostragem: int

    canais = {
        "FP1": None,
        "FP2": None,
        "F7": None,
        "F3": None,
        "FZ": None,
        "F4": None,
        "F8": None,
        "A1": None,
        "T3": None,
        "C3": None,
        "CZ": None,
        "C4": None,
        "T4": None,
        "A2": None,
        "T5": None,
        "P3": None,
        "Pz": None,
        "P4": None,
        "T6": None,
        "O1": None,
        "O2": None,
    }

    def __init__(self, sinal_arquivo_edf: edfreader.EdfReader):
        canais_no_sinal = sinal_arquivo_edf.getSignalLabels()
        labels = list(self.canais.keys())

        self.frequencia_de_amostragem = sinal_arquivo_edf.getSampleFrequency(0)

        for i in range(len(canais_no_sinal)):
            # Obtenho o sinal inteiro do respectivo canal iterado
            sinal_do_canal = sinal_arquivo_edf.readSignal(i)

            # sinal_do_canal = preprocessing.normalize(
            # np.reshape(sinal_do_canal, (1, -1))
            # )

            # print(sinal_do_canal.shape())

            # Obtenho o nome do canal iterado
            label_do_canal = canais_no_sinal[i]

            # Busco na lista de canais que especifiquei na propriedade "canais" do objeto, qual corresponde ao canal que está sendo iterado no "for"
            canal_a_ser_salvo = next(
                filter(
                    lambda nome_canal: nome_canal.lower() in label_do_canal.lower(),
                    labels,
                ),
                None,
            )

            # Se ele existe, atribui o sinal no dicionario com o indice respectivo do canal, caso contrario, printa um erro
            if canal_a_ser_salvo is not None:
                self.canais[canal_a_ser_salvo] = sinal_do_canal

    def decomporSinalEmFaixaDeFrequencia(self, faixa_de_frequencia):
        valores_dos_canais = [np.array(canal) for canal in self.canais.values()]

        sinal_decomposto = ProcessamentoDoSinal.butter_bandpass_filter(
            valores_dos_canais,
            faixa_de_frequencia[0],
            faixa_de_frequencia[1],
            self.frequencia_de_amostragem,
        )

        return sinal_decomposto
