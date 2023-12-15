import numpy as np

def get_depth(dispM, K1, K2, R1, R2, t1, t2):
    """
    creates a depth map from a disparity map (DISPM).
    """
    c1 = -np.linalg.inv(K1 @ R1) @ (K1 @ t1)
    c2 = -np.linalg.inv(K2 @ R2) @ (K2 @ t2)

    b = np.linalg.norm(c1 - c2)

    f = K1[0, 0]

    depthM = b * f / np.where(dispM == 0, np.inf, dispM)
    depthM[dispM == 0] = 0

    return depthM

