from pyedflib import edfreader


class SinalEEG(object):
    canais = {"Fp1": [], "Fp2": [], "F7": [],
              "F3": [], "Fz": [], "F4": [],
              "F8": [], "A1": [], "T3": [],
              "C3": [], "Cz": [], "C4": [],
              "T4": [], "A2": [], "T5": [],
              "P3": [], "Pz": [], "P4": [],
              "T6": [], "O1": [], "O2": []}

    def __init__(self, sinal_arquivo_edf: edfreader.EdfReader):
        canais_no_sinal = sinal_arquivo_edf.getSignalLabels()
        labels = list(self.canais.keys())

        for i in range(len(canais_no_sinal)):
            # Obtenho o sinal inteiro do respectivo canal iterado
            sinal_do_canal = sinal_arquivo_edf.readSignal(i)

            # Obtenho o nome do canal iterado
            label_do_canal = canais_no_sinal[i]

            # Busco na lista de canais que especifiquei na propriedade "canais" do objeto, qual corresponde ao canal que está sendo iterado no "for"
            canal_a_ser_salvo = next(filter(
                lambda nome_canal: nome_canal.lower() in label_do_canal.lower(), labels), None)

            # Se ele existe, atribui o sinal no dicionario com o indice respectivo do canal, caso contrario, printa um erro
            if canal_a_ser_salvo is not None:
                self.canais[canal_a_ser_salvo] = sinal_do_canal
            else:
                print("label_do_canal ", label_do_canal, " inexistente")
