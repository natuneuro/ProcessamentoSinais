import numpy as np
import math


class TrechoSinal(object):

    sinal = []
    tempo_inicio: float
    tempo_final: float
    ocorre_conv: bool

    def __init__(self, t_sinal, ini, fim, conv=False):
        self.sinal = t_sinal
        self.tempo_inicio = ini
        self.tempo_final = fim
        self.ocorre_conv = conv
