import cv2
from matplotlib import pyplot as plt
import numpy as np


def project_3d_points(P, points_3d):

    
    points_2dh = np.dot(np.column_stack((points_3d, np.ones((points_3d.shape[0], 1)))), P.T)

    points_2dh_norm = points_2dh / points_2dh[:, 2][:, np.newaxis]

    points_2d = points_2dh_norm[:, :2]

    return points_2d

def load_camera_parameters(file_path):
    parameters = np.loadtxt(file_path, usecols=range(1, 22))
    return parameters

# Load images
Images = ['../data/templeR0013.png','../data/templeR0014.png','../data/templeR0016.png','../data/templeR0043.png','../data/templeR0045.png']


# Load camera parameters
P0_values = load_camera_parameters('../data/templeR_par.txt')


# Reshape the array into a 3D array
num_params = len(P0_values)


P0 = P0_values.reshape((num_params, 21))

min_coords = np.array([-0.023121, -0.038009, -0.091940])
max_coords = np.array([0.078626, 0.121636, -0.017395])

corners_3d = np.array([
    [min_coords[0], min_coords[1], min_coords[2]],
    [min_coords[0], min_coords[1], max_coords[2]],
    [min_coords[0], max_coords[1], min_coords[2]],
    [min_coords[0], max_coords[1], max_coords[2]],
    [max_coords[0], min_coords[1], min_coords[2]],
    [max_coords[0], min_coords[1], max_coords[2]],
    [max_coords[0], max_coords[1], min_coords[2]],
    [max_coords[0], max_coords[1], max_coords[2]]
])

num_images = 5

for i in range(num_images):
    Im = cv2.imread(Images[i])
    K_matrix = P0[i, :9].reshape(3, 3)
    R_matrix = P0[i, 9:18].reshape(3, 3)
    t_vector = P0[i, 18:21].reshape(3, 1)
    R_matrix = np.hstack((R_matrix, t_vector))

    P_matrix = np.dot(K_matrix, R_matrix)

    points_2d = project_3d_points(P_matrix,corners_3d)


    plt.imshow(cv2.cvtColor(Im, cv2.COLOR_BGR2RGB))

    plt.scatter(points_2d[:, 0], points_2d[:, 1], c='red', marker='o')

    plt.show()
