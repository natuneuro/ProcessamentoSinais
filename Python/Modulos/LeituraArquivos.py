import tkinter as tk
from tkinter import filedialog

import pyedflib

from Classes import SinalEEG


def ObterNomeArquivoEDF():
    root = tk.Tk()
    root.withdraw()

    nome_arquivo = filedialog.askopenfilename(
        title="Selecione o arquivo .EDF",
        filetypes=(("EDF files", "*.edf"), ("all files", "*.*")),
    )

    return nome_arquivo


def ImportarSinalEEG():
    nome_arquivo_edf = ObterNomeArquivoEDF()
    sinal_arquivo_edf = pyedflib.EdfReader(nome_arquivo_edf)
    sinal_eeg = SinalEEG.SinalEEG(sinal_arquivo_edf)

    nome_arquivo_tse = nome_arquivo_edf.replace(".edf", ".tse")

    return sinal_eeg


def ImportarArquivoTSE():
    pass
