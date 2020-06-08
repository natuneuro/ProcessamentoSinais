from Classes import SinalDividido
import string


def ver_ocorre_conv(sinal, lista_conv, evento):

    if (evento.inicio < sinal.tempo_inicio < evento.fim) or (evento.inicio < sinal.tempo_final < evento.fim):
        for i in range(0, len(lista_conv)-1):
            if lista_conv[i] == evento.tipo:
                return True

    return False
