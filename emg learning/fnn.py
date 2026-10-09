import numpy as np
import pandas as pd

#reading the document
df = pd.read_csv("emg_features.csv") 

#getting the columns containing the important features
feature_columns = [              
    f"{feature}_ch{channel}"
    for channel in range(1, 9)
    for feature in ["MAV", "WL", "ZC"]
]

#making sure the subject_id numbers are integers to prevent confusion
df["subject_id"] = df["subject_id"].astype(int) 

#training dataset is windows belonging to subjects 1 to 25 and class 1 to 6
train = df["subject_id"].between(6, 30) & df["class"].between(1, 6) 
#val = df["subject_id"].between(1, 5) & df["class"].between(1, 6) 

#converting data frame to numpy array
x = df.loc[train, feature_columns].to_numpy()
#x_val = df.loc[val, feature_columns].to_numpy()

#standardization
mean = np.mean(x, axis=0)
std = np.std(x, axis=0)

x = (x - mean) / std
#x_val = (x_val - mean) / std

y = df.loc[train, "class"].to_numpy()
#y_val = df.loc[val, "class"].to_numpy()

W1 = np.random.randn(24, 32) * np.sqrt(2 / 24)
B1 = np.zeros((1, 32))

W2 = np.random.randn(32, 6) * np.sqrt(2 / 32)
B2 = np.zeros((1, 6))

def ReLu(Z):
    return np.maximum(0, Z)

def softmax(Z):
    Z = Z - np.max(Z, axis=1, keepdims=True)
    exp_Z = np.exp(Z)
    return exp_Z / np.sum(exp_Z, axis=1, keepdims=True)

def fprop(x, w1, b1, w2, b2):
    z1 = x @ w1 + b1
    a1 = ReLu(z1)
    z2 = a1 @ w2 + b2
    p = softmax(z2)

    return z1, a1, z2, p

def bprop(x, y, p, z1, a1, w2):
    Y = np.eye(6)[y-1]
    N = x.shape[0]
    dz2 = (p - Y) / N
    dw2 = a1.T @ dz2
    db2 = np.sum(dz2, axis=0, keepdims=True)
    da1 = dz2 @ w2.T
    dz1 = da1 * (z1 > 0)
    dw1 = x.T @ dz1
    db1 = np.sum(dz1, axis=0, keepdims=True)

    return dw1, db1, dw2, db2

def update_params(w1, w2, b1, b2, dw1, dw2, db1, db2, lr):
    wn1 = w1 - lr * dw1
    wn2 = w2 - lr * dw2
    bn1 = b1 - lr * db1
    bn2 = b2 - lr * db2

    return wn1, wn2, bn1, bn2

def cost(p, y):
    N = y.shape[0]
    correct_probs = p[np.arange(N), y - 1]

    return -np.mean(np.log(correct_probs))


def gradient_descent(x, y, w1, b1, w2, b2, lr, epochs):

    for epoch in range(epochs):

        # Forward propagation
        z1, a1, z2, p = fprop(x, w1, b1, w2, b2)

        # Cost
        J = cost(p, y)

        predictions = np.argmax(p, axis=1) + 1
        accuracy = np.mean(predictions == y)

        # Backpropagation
        dw1, db1, dw2, db2 = bprop(x, y, p, z1, a1, w2)

        # Gradient descent update
        w1, w2, b1, b2 = update_params(
            w1, w2, b1, b2,
            dw1, dw2, db1, db2,
            lr
        )

        if epoch % 1 == 0:
            print("Epoch:", epoch, "Cost:", J, "Accuracy:", accuracy)

    return w1, b1, w2, b2 

"""def gradient_descent(x_train, y_train, x_val, y_val,
                     w1, b1, w2, b2, lr, epochs):

    epoch_history = []
    train_acc_history = []
    val_acc_history = []

    for epoch in range(epochs):

        # ---------- TRAINING ----------
        z1, a1, z2, p = fprop(
            x_train, w1, b1, w2, b2
        )

        dw1, db1, dw2, db2 = bprop(
            x_train, y_train, p, z1, a1, w2
        )

        w1, w2, b1, b2 = update_params(
            w1, w2, b1, b2,
            dw1, dw2, db1, db2,
            lr
        )

        # ---------- CHECKPOINT ----------
        if epoch % 1 == 0:

            # Training accuracy using current weights
            _, _, _, p_train = fprop(
                x_train, w1, b1, w2, b2
            )

            train_predictions = np.argmax(p_train, axis=1) + 1
            train_accuracy = np.mean(
                train_predictions == y_train
            )

            # Validation accuracy
            _, _, _, p_val = fprop(
                x_val, w1, b1, w2, b2
            )

            val_predictions = np.argmax(p_val, axis=1) + 1
            val_accuracy = np.mean(
                val_predictions == y_val
            )

            epoch_history.append(epoch)
            train_acc_history.append(train_accuracy)
            val_acc_history.append(val_accuracy)

            print(
                "Epoch:", epoch,
                "Train Accuracy:", train_accuracy,
                "Validation Accuracy:", val_accuracy
            )

    return (
        w1, b1, w2, b2,
        epoch_history,
        train_acc_history,
        val_acc_history
    )"""

W1, B1, W2, B2 = gradient_descent(
    x, y,
    W1, B1, W2, B2,
    lr=0.2,
    epochs=6000
)

# Validation subjects

val = (
    df["subject_id"].between(1, 5)
    & df["class"].between(1, 6)
)

# Get validation inputs and labels
x_val = df.loc[val, feature_columns].to_numpy()
y_val = df.loc[val, "class"].to_numpy()

# IMPORTANT: use the TRAINING mean and std
x_val = (x_val - mean) / std

# Forward propagation only
z1_val, a1_val, z2_val, p_val = fprop(
    x_val, W1, B1, W2, B2
)

# Predictions
predictions_val = np.argmax(p_val, axis=1) + 1

# Validation accuracy and cost
accuracy_val = np.mean(predictions_val == y_val)
cost_val = cost(p_val, y_val)

print("val accuracy:", accuracy_val)
print("val cost:", cost_val) 

#testing

test = (
    df["subject_id"].between(31, 36)
    & df["class"].between(1, 6)
)

# Get validation inputs and labels
x_test = df.loc[test, feature_columns].to_numpy()
y_test = df.loc[test, "class"].to_numpy()

# IMPORTANT: use the TRAINING mean and std
x_test = (x_test - mean) / std

# Forward propagation only
z1_test, a1_test, z2_test, p_test = fprop(
    x_test, W1, B1, W2, B2
)

# Predictions
predictions_test = np.argmax(p_test, axis=1) + 1

# Validation accuracy and cost
accuracy_test = np.mean(predictions_test == y_test)
cost_test = cost(p_test, y_test)

print("test accuracy:", accuracy_test)
print("test cost:", cost_test) 

"""
W1, B1, W2, B2, epochs_plot, train_acc, val_acc = gradient_descent(
    x_train,
    y,
    x_val,
    y_val,
    W1,
    B1,
    W2,
    B2,
    lr=0.1,
    epochs=6000
)

import matplotlib.pyplot as plt

plt.plot(
    epochs_plot,
    np.array(train_acc) * 100,
    label="Training Accuracy"
)

plt.plot(
    epochs_plot,
    np.array(val_acc) * 100,
    label="Validation Accuracy"
)

plt.xlabel("Epoch")
plt.ylabel("Accuracy (%)")
plt.title("Training and Validation Accuracy vs Epoch")
plt.legend()
plt.grid()

plt.show() """