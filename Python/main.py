
import pyedflib
import numpy as np

teste_edf = r'C:\Users\bruno\Desktop\ProcessamentoSinais\Dados\tuh_eeg_seizure\train\02_tcp_le\013\00001357\s001_2004_06_04\00001357_s001_t000.edf'

sinal = pyedflib.EdfReader(teste_edf)
n = sinal.signals_in_file
print(n)
signal_labels = sinal.getSignalLabels()
