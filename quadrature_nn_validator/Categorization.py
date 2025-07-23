import numpy as np

# Reference S-parameters as a 16x1 column vector
reference_vector = np.array([
    0.054720816,
    0.66087208,
    0.66116568,
    0.075326263,
    0.66087203,
    0.054705482,
    0.07531158,
    0.66116566,
    0.66116578,
    0.07531144,
    0.054705345,
    0.6608722,
    0.075326221,
    0.6611656,
    0.66087205,
    0.054720507
]).reshape((16, 1))

TOLERANCE = 0.04

def main():
    lambdasweep = np.load("lambdasweep.npy")
    Z0root2sweep = np.load("Z0root2sweep.npy")
    Z0sweep = np.load("Z0sweep.npy")
    print("Categorizing lambdasweep...")
    lambdasweep_categorized = categorize_samples_onehot(lambdasweep, "lambdasweep")
    print("Categorizing Z0root2sweep...")
    Z0root2sweep_categorized = categorize_samples_onehot(Z0root2sweep, "Z0root2sweep")
    print("Categorizing Z0sweep...")
    Z0sweep_categorized = categorize_samples_onehot(Z0sweep, "Z0sweep")
    print("Categorization complete.")
    totalsweep = np.concatenate((lambdasweep, Z0root2sweep, Z0sweep), axis=1)
    totalresult = np.concatenate((lambdasweep_categorized, Z0root2sweep_categorized, Z0sweep_categorized), axis=0)
    # Generate a random permutation of indices
    perm = np.random.permutation(totalresult.shape[0])

    # Shuffle A's columns and B's rows using the same permutation
    shuffledsweep = totalsweep[:, perm]   # shuffle columns of A
    shuffledresult = totalresult[perm, :]   # shuffle rows of B
    np.save("shuffledsweep.npy", shuffledsweep)
    np.save("shuffledresult.npy", shuffledresult)

def categorize_samples_onehot(matrix: np.ndarray, name: str) -> np.ndarray:
    """
    Returns a one-hot encoded matrix of shape [m, 4] where:
    - Column 0: Accepted
    - Column 1: faultyZ0
    - Column 2: faultyZ0root2
    - Column 3: faultyLambda
    """
    if matrix.shape[0] != 16:
        raise ValueError("Input matrix must have 16 rows (S-parameters).")

    m = matrix.shape[1]
    diff = np.abs(matrix - reference_vector)
    within_tolerance = np.all(diff <= TOLERANCE, axis=0)

    # Determine faulty column index based on name
    name_lower = name.lower()
    if "z0root2" in name_lower:
        fault_index = 2
    elif "lambda" in name_lower:
        fault_index = 3
    elif "z0" in name_lower:
        fault_index = 1
    else:
        raise ValueError("Unknown test category in matrix name (should contain 'Z0', 'Z0root2', or 'lambda').")

    # Initialize m x 4 zero matrix
    result = np.zeros((m, 4), dtype=int)

    # Fill one-hot matrix
    for i in range(m):
        if within_tolerance[i]:
            result[i, 0] = 1  # Accepted
        else:
            result[i, fault_index] = 1  # Faulty in one of the three categories

    return result

if __name__ == "__main__":
    main()

# Example usage:
# test_matrix = np.random.rand(16, 5)
# output = categorize_samples_onehot(test_matrix, "Z0")
# print(output)
