import numpy as np
import matplotlib.pyplot as plt
import cv2
import os
from eightpoint import eightpoint
from epipolarCorrespondence import epipolarCorrespondence
from essentialMatrix import essentialMatrix
from camera2 import camera2
from triangulate import triangulate
from displayEpipolarF import displayEpipolarF
from epipolarMatchGUI import epipolarMatchGUI

def load_data():
    image1 = cv2.imread('../data/im1.png')
    image2 = cv2.imread('../data/im2.png')
    correspondences = np.load('../data/someCorresp.npy', allow_pickle=True).tolist()
    points1 = correspondences['pts1']
    points2 = correspondences['pts2']
    max_distance = correspondences['M']
    return image1, image2, points1, points2, max_distance

def compute_fundamental_matrix(points1, points2, max_distance):
    F = eightpoint(points1, points2, max_distance)
    return F

def find_corresponding_points(image1, image2, F):
    temple_points = np.load('../data/templeCoords.npy', allow_pickle=True).tolist()['pts1']
    corresponding_points = np.zeros_like(temple_points)
    for i, point in enumerate(temple_points):
        corresponding_points[i] = epipolarCorrespondence(image1, image2, F, point)
    return temple_points, corresponding_points

def load_intrinsics():
    intrinsics = np.load('../data/intrinsics.npy', allow_pickle=True).tolist()
    return intrinsics['K1'], intrinsics['K2']

def compute_camera_matrices(F, K1, K2, points1, points2):
    E = essentialMatrix(F, K1, K2)
    P1 = K1 @ np.hstack((np.eye(3), np.zeros((3, 1))))
    P2_candidates = camera2(E)
    return P1, P2_candidates

def triangulate_points(P1, P2_candidates, points1, points2):
    min_distance = float('inf')
    best_P2 = None
    best_pts3d = None

    for i in range(4):
        P2_candidate = P2_candidates[:, :, i]

        if np.linalg.det(P2_candidate[:3, :3]) != 1:
            P2_candidate = K2 @ P2_candidate

        pts3d_candidate = triangulate(P1, points1, P2_candidate, points2)

        x1 = P1 @ np.vstack((pts3d_candidate.T, np.ones((1, pts3d_candidate.shape[0]))))
        x2 = P2_candidate @ np.vstack((pts3d_candidate.T, np.ones((1, pts3d_candidate.shape[0]))))

        epsilon = 1e-6
        x1 /= x1[2, :]
        x2 /= x2[2, :]

        if np.all(pts3d_candidate[:, 2] > 0):
            distance1 = np.linalg.norm(points1 - x1[:2, :].T) / pts3d_candidate.shape[0]
            distance2 = np.linalg.norm(points2 - x2[:2, :].T) / pts3d_candidate.shape[0]
            distance = distance1 + distance2

            if distance < min_distance:
                min_distance = distance
                min_distance1 = distance1
                min_distance2 = distance2
                best_P2 = P2_candidate
                best_pts3d = pts3d_candidate
    print(f'Min pts1 error: {min_distance1}')
    print(f'Min pts2 error: {min_distance2}')
    return best_P2, best_pts3d

image1, image2, points1, points2, max_distance = load_data()
F = compute_fundamental_matrix(points1, points2, max_distance)
epipolarMatchGUI(image1,image2,F)
temple_points, corresponding_points = find_corresponding_points(image1, image2, F)
K1, K2 = load_intrinsics()
P1, P2_candidates = compute_camera_matrices(F, K1, K2, temple_points, corresponding_points)
best_P2, best_pts3d = triangulate_points(P1, P2_candidates, temple_points, corresponding_points)

# Plot the 3D points
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
ax.scatter(best_pts3d[:, 0], best_pts3d[:, 1], best_pts3d[:, 2], c='k', marker='.')

ax.set_box_aspect([1,1,1])
plt.show()

R1, t1 = np.eye(3), np.zeros((3, 1))
R2, t2 = best_P2[:, :3], best_P2[:, 3]

os.makedirs('../results/extrinsics', exist_ok=True)
np.save('../results/extrinsics', {'R1': R1, 't1': t1, 'R2': R2, 't2': t2})

print("Extrinsics saved.")