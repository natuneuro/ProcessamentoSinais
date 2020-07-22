import tkinter as tk
from tkinter import filedialog

import numpy as np

from Classes import Evento


def importar_evento():

    root = tk.Tk()
    root.withdraw()

    f_tse = filedialog.askopenfilename(
        title="Selecione o arquivo .tse",
        filetypes=(("tse files", "*.tse"), ("all files", "*.*")),
    )

    # f_tse = open("caminho_arquivo", "r")

    # conteudo = np.loadtxt(f_tse, dtype=('f4', 'f4', 'str', 'i4'), skiprows=2)

    conteudo = np.genfromtxt(f_tse, dtype="str", skip_header=2)

    quantidade_eventos = len(conteudo[:])

    eventos = []

    for i in range(0, quantidade_eventos - 1):
        evento = Evento.Evento(
            float(conteudo[i][0]),
            float(conteudo[i][1]),
            conteudo[i][2],
            float(conteudo[i][3]),
        )
        eventos.append(evento)

    return eventos
