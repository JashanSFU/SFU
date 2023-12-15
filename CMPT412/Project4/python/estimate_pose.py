import numpy as np
from scipy.linalg import svd

def estimate_pose(x, X):

    num_points = X.shape[1]
    design_matrix = np.zeros((2 * num_points, 12))

    for i in range(num_points):
        world_point = X[:, i]
        image_point = x[:, i]

        design_matrix[2 * i] = [-world_point[0], -world_point[1], -world_point[2], -1, 
                                0, 0, 0, 0, 
                                image_point[0] * world_point[0], image_point[0] * world_point[1], 
                                image_point[0] * world_point[2], image_point[0]]

        design_matrix[2 * i + 1] = [0, 0, 0, 0, 
                                    -world_point[0], -world_point[1], -world_point[2], -1, 
                                    image_point[1] * world_point[0], image_point[1] * world_point[1], 
                                    image_point[1] * world_point[2], image_point[1]]

    _, _, Vt = np.linalg.svd(design_matrix)

    projection_matrix = Vt[-1].reshape((3, 4))

    return projection_matrix