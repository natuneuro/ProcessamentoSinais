from Classes import TrechoSinal
from Modulos import VerificaConv


def associa_trecho_evento (trechos_sinal, eventos):

    quantidade_trechos = len(trechos_sinal)
    lista_tipos_conv = ["cpsz", "gnsz", "absz", "tnsz", "cnsz", "tcsz"]

    for i in range(0, quantidade_trechos - 1):
        for j in range(0, len(eventos)):
            #sinal_div[i].ocorre_conv = VerificaConv.ver_ocorre_conv(sinal_div[i], lista_tipos_conv, eventos[j])
            #if sinal_div[i].ocorre_conv:
                #break
            #conv = VerificaConv.ver_ocorre_conv(trechos_sinal[i], lista_tipos_conv, eventos[j])
            #trechos_sinal[i].ocorre_conv = conv
            trechos_sinal[i].ocorre_conv = VerificaConv.ver_ocorre_conv(trechos_sinal[i], lista_tipos_conv, eventos[j])
            if trechos_sinal[i].ocorre_conv:
                break

    return trechos_sinal
