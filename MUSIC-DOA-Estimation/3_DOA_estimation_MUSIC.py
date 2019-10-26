import numpy as np
import matplotlib.pyplot as plt
from cmath import e, pi, sin, cos

N = 5
M = 10
p = 100
fc = 1e6
fs = 1e7
c = 3e8
d = 150


# Steering Vector as a function of theta
def a(theta):
    a1 = np.exp(-1j * 2 * pi * fc * d * (np.cos(theta) / c) * np.arange(M))
    return a1.reshape((M, 1))


# recieved signal data
X = np.load('recieved_signal_data.npy')
print("Recieved Signal X: ", X.shape)

# empirical covariance matrix of X
S = X @ X.conj().T / p
print("Empirical Covariance Matrix S : ", S.shape)

# finding eigen values and eigen vectors
eigvals, eigvecs = np.linalg.eig(S)
# eigen values are real as S is Hermitian matrix
eigvals = eigvals.real

# sorting eig vals and eig vecs in decreasing order of eig vals
idx = eigvals.argsort()[::-1]
eigvals = eigvals[idx]
eigvecs = eigvecs[:, idx]

# Plotting Eigen Values
fig, ax = plt.subplots(figsize=(10, 4))
ax.scatter(np.arange(N), eigvals[:N], label="N EigVals from Source")
ax.scatter(np.arange(N, M), eigvals[N:], label="M-N EigVals from Noise")
plt.title('Visualize Source and Noise Eigenvalues')
plt.legend()

# separating source and noise eigvectors
Us, Un = eigvecs[:, :N], eigvecs[:, N:]
print("Source Eigen Values : Us: ", Us.shape)
print("Noise Eigen Values : Un: ", Un.shape)

# plotting original DOAs for comparison with peaks
fig, ax = plt.subplots(figsize=(10, 4))
doa = np.array([20, 50, 85, 110, 145])
print("Original Directions of Arrival (degrees): \n", doa)
for k in range(len(doa)):
    plt.axvline(x=doa[k], color='red', linestyle='--')


def P(theta):
    return (1 / (a(theta).conj().T @ Un @ Un.conj().T @ a(theta)))[0, 0]


# searching for all possible theta
theta_vals = np.arange(0, 181, 1)
P_vals = np.array([P(val * pi / 180.0) for val in theta_vals]).real

# Plotting P_vals vs theta to find peaks
plt.plot(np.abs(theta_vals), P_vals)
plt.xticks(np.arange(0, 181, 10))
plt.xlabel('theta')
plt.title('Dotted Lines = Actual DOA    Peaks = Estimated DOA')

plt.legend()
plt.grid()
plt.show()
