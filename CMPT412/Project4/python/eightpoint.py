import numpy as np
from numpy.linalg import svd
from refineF import refineF
from displayEpipolarF import displayEpipolarF
import matplotlib.pyplot as plt

import numpy as np
from numpy.linalg import svd

def eightpoint(pts1, pts2, M):
    """
    Computes the fundamental matrix using the eight-point algorithm.
    Args:
        pts1: Nx2 matrix of (x, y) coordinates in the first image.
        pts2: Nx2 matrix of (x, y) coordinates in the second image.
        M: The scaling factor, typically max(image width, image height).
    Returns:
        The fundamental matrix, F.
    """

    # Normalize the points by dividing by M
    norm_pts1 = pts1 / M
    norm_pts2 = pts2 / M

    A = np.column_stack((norm_pts2[:, 0] * norm_pts1[:, 0],
                         norm_pts2[:, 0] * norm_pts1[:, 1],
                         norm_pts2[:, 0],
                         norm_pts2[:, 1] * norm_pts1[:, 0],
                         norm_pts2[:, 1] * norm_pts1[:, 1],
                         norm_pts2[:, 1],
                         norm_pts1[:, 0],
                         norm_pts1[:, 1],
                         np.ones(pts1.shape[0])))


    _, _, V = svd(A)
    F_normalized = V[:,-1].reshape(3, 3)

    U, S, Vt = svd(F_normalized)
    S[2] = 0  
    F_rank2 = U @ np.diag(S) @ Vt

    F_refined = refineF(F_rank2.flatten(), norm_pts1, norm_pts2).reshape(3, 3)

    denormalization_matrix = np.diag([1/M, 1/M, 1])
    F = denormalization_matrix.T @ F_refined @ denormalization_matrix

    return F