import os
import tkinter as tk
from tkinter import filedialog


def LeituraArquivosEDF():
    root = tk.Tk()
    root.withdraw()

    nome_arquivo = filedialog.askdirectory(
        title="Selecione a pasta que contem os arquivos .EDF")

    arquivos_a_serem_lidos = []

    for root, dirs, files in os.walk(nome_arquivo):
        for file in files:
            if file.endswith(".edf"):
                arquivo_edf_a_ser_lido = os.path.join(root, file)
                arquivo_edf_a_ser_lido = arquivo_edf_a_ser_lido.replace(
                    r'/', '\\')
                arquivos_a_serem_lidos.append(arquivo_edf_a_ser_lido)

    return arquivos_a_serem_lidos


LeituraArquivosEDF()
