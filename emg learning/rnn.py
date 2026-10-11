import numpy as np
import pandas as pd
from pathlib import Path

root = Path(r"C:\Users\ikito\ddca\EMG_data_for_gestures-master")

train_subjects = [f"{i:02d}" for i in range(6, 31)]
val_subjects   = [f"{i:02d}" for i in range(1, 6)]
test_subjects  = [f"{i:02d}" for i in range(31, 37)]

def get_recording_files(subjects):
    files = []

    for subject in subjects:
        subject_folder = root / subject

        for file in subject_folder.glob("*.txt"):
            files.append(file)

    return files

train_files = get_recording_files(train_subjects)
val_files   = get_recording_files(val_subjects)
test_files  = get_recording_files(test_subjects)


channels = [              
    f"channel{channel}"
    for channel in range(1, 9)
]


def training(num_epochs, lr):
 hidden_size = 32 

 for epoch in range(num_epochs):

    for file in train_files:

        df = pd.read_csv(file, sep="\t")

        x = df[channels].to_numpy()
        y = df["class"].to_numpy()

        print(x)

        