import pyedflib
import numpy as np
import tkinter as tk
from Classes import SinalEEG
from tkinter import filedialog


def ImportarArquivoEDF():
    root = tk.Tk()
    root.withdraw()

    nome_arquivo = filedialog.askopenfilename(
        title="Selecione o arquivo .EDF", filetypes=(("EDF files", "*.edf"), ("all files", "*.*")))

    return pyedflib.EdfReader(nome_arquivo)


def ImportarSinalEEG():
    sinal_arquivo_edf = ImportarArquivoEDF()
    sinal_eeg = SinalEEG.SinalEEG(sinal_arquivo_edf)
    return sinal_eeg
