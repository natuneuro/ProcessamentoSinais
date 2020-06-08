

class SinalDividido(object):
    sinal: list
    tempo_inicio = 0
    tempo_final = 0
    ocorre_conv: bool

    def __init__(self, sinal, tempo_inicio, tempo_fim, conv=False):
        self.sinal = sinal
        self.tempo_inicio = tempo_inicio
        self.tempo_final = tempo_fim
        self.ocorre_conv = conv
