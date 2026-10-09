import pandas as pd

df = pd.read_csv("emg_features.csv")
df = df.loc[df["class"].between(1, 6)].copy()

print(df.shape)
print(df.columns.tolist())
print(df.head())

feature_columns = [
    f"{feature}_ch{channel}"
    for channel in range(1, 9)
    for feature in ["MAV", "WL", "ZC"]
]

x = df[feature_columns]
y = df["class"]

print("x shape:", x.shape)
print("y shape:", y.shape)
print("Feature columns:", feature_columns)
print("Class counts:")
print(y.value_counts().sort_index())

train_mask = df["subject_id"].between(1, 25)
val_mask = df["subject_id"].between(26, 30)
test_mask = df["subject_id"].between(31, 36)

x_train = x.loc[train_mask]
y_train = y.loc[train_mask]

x_val = x.loc[val_mask]
y_val = y.loc[val_mask]

x_test = x.loc[test_mask]
y_test = y.loc[test_mask]

print("Training:", x_train.shape, y_train.shape)
print("Validation:", x_val.shape, y_val.shape)
print("Test:", x_test.shape, y_test.shape)

print("\nClass counts by split:")
print(pd.DataFrame({
    "train": y_train.value_counts(),
    "validation": y_val.value_counts(),
    "test": y_test.value_counts()
}).fillna(0).astype(int).sort_index())

from sklearn.ensemble import RandomForestClassifier

model = RandomForestClassifier(
    n_estimators = 700,
    max_depth= 15,
    max_features= 8,
    min_samples_leaf= 5,
    criterion= "gini",
    random_state = 42,
    n_jobs = -1
)

print("\nTraining the forest...")
model.fit(x_train, y_train)
print("Training complete.")

from sklearn.metrics import accuracy_score, classification_report, confusion_matrix

y_val_pred = model.predict(x_val)

print("\nValidation accuracy:")
print(accuracy_score(y_val, y_val_pred))

print("\nClassification report:")
print(classification_report(y_val, y_val_pred, digits=3, zero_division=0))

print("\nConfusion matrix:")
print(confusion_matrix(y_val, y_val_pred, labels=[1, 2, 3, 4, 5, 6]))

y_test_pred = model.predict(x_test)

print("\nTest accuracy:")
print(accuracy_score(y_test, y_test_pred))

print("\nTest classification report:")
print(classification_report(
    y_test,
    y_test_pred,
    digits=3,
    zero_division=0
))

print("\nTest confusion matrix:")
print(confusion_matrix(
    y_test,
    y_test_pred,
    labels=[1, 2, 3, 4, 5, 6]
))
"""
import joblib

joblib.dump(
    {
        "model": model,
        "feature_columns": feature_columns
    },
    "emg_random_forest.joblib"
)"""